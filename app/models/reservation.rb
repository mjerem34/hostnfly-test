# frozen_string_literal: true

class Reservation < ApplicationRecord
  include Overlapping
  include StartDateIsBeforeEndDate

  belongs_to :listing

  validates :start_date, :end_date, presence: true
  validates :listing_id, uniqueness: { scope: %i[start_date end_date] }

  validate :nonoverlapping_booking
  validate :start_date_is_before_end_date

  after_create_commit :create_checkout_checkin_mission
  before_destroy :destroy_associated_missions

  private

  def create_checkout_checkin_mission
    return if existing_last_checkout_on_same_day

    listing.missions.create!(listing_id: listing_id, mission_type: :checkout_checkin,
                             date: end_date, price: 10 * listing.num_rooms)
  end

  def existing_last_checkout_on_same_day
    listing.missions.find_by(mission_type: :last_checkout, date: end_date)
  end

  def destroy_associated_missions
    listing.missions.where('date >= ? AND date <= ?', start_date, end_date).delete_all
  end
end
