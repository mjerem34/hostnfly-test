# frozen_string_literal: true

class Booking < ApplicationRecord
  include Overlapping
  include StartDateIsBeforeEndDate

  belongs_to :listing

  validates :start_date, :end_date, presence: true
  validates :listing_id, uniqueness: { scope: %i[start_date end_date] }

  validate :nonoverlapping_booking
  validate :start_date_is_before_end_date

  after_create_commit :create_first_checkin_mission, :create_last_checkout_mission
  before_destroy :destroy_associated_missions

  private

  def create_first_checkin_mission
    listing.missions.create!(mission_type: :first_checkin, date: start_date,
                             price: 10 * listing.num_rooms)
  end

  def create_last_checkout_mission
    listing.missions.create!(mission_type: :last_checkout, date: end_date,
                             price: 5 * listing.num_rooms)
  end

  def destroy_associated_missions
    listing.missions.where('date >= ? AND date <= ?', start_date, end_date).delete_all
  end
end
