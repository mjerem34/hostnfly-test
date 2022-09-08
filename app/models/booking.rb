# frozen_string_literal: true

class Booking < ApplicationRecord
  include Overlapping
  include StartDateIsBeforeEndDate

  belongs_to :listing

  validates :start_date, :end_date, presence: true
  validates :listing_id, uniqueness: { scope: %i[start_date end_date] }

  validate :nonoverlapping_booking
  validate :start_date_is_before_end_date
end
