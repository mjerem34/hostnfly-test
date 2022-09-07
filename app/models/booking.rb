# frozen_string_literal: true

class Booking < ApplicationRecord
  belongs_to :listing

  validates :start_date, :end_date, presence: true
  validates :listing_id, uniqueness: { scope: %i[start_date end_date] }

  validate :start_date_is_before_end_date
  validate :nonoverlapping_booking

  private

  def start_date_is_before_end_date
    return if start_date.blank? || end_date.blank?
    return if end_date > start_date

    errors.add(:start_date, :greater_than_end_date)
  end

  def nonoverlapping_booking
    return unless overlapping_other_booking?

    errors.add(:start_date, :overlap)
    errors.add(:end_date, :overlap)
  end

  def overlapping_other_booking?
    other_booking_overlapped.exists?
  end

  def other_booking_overlapped
    Booking.where(listing_id: listing_id)
           .where.not(id: id)
           .where('start_date < :end_date AND end_date > :start_date',
                  start_date: start_date, end_date: end_date)
  end
end
