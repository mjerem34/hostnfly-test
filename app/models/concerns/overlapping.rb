# frozen_string_literal: true

module Overlapping
  extend ActiveSupport::Concern
  included do
    validate :nonoverlapping_booking
  end

  private

  def nonoverlapping_booking
    return unless overlapping_other_booking?

    errors.add(:start_date, :overlap)
    errors.add(:end_date, :overlap)
  end

  def overlapping_other_booking?
    other_booking_overlapped.exists?
  end

  def other_booking_overlapped
    self.class.where(listing_id: listing_id)
        .where.not(id: id)
        .where('start_date < :end_date AND end_date > :start_date',
               start_date: start_date, end_date: end_date)
  end
end
