# frozen_string_literal: true

class Reservation < ApplicationRecord
  include Overlapping
  include StartDateIsBeforeEndDate

  belongs_to :listing

  validates :start_date, :end_date, presence: true
  validates :listing_id, uniqueness: { scope: %i[start_date end_date] }
end
