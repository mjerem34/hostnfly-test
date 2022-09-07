# frozen_string_literal: true

module StartDateIsBeforeEndDate
  extend ActiveSupport::Concern
  included do
    validate :start_date_is_before_end_date
  end

  private

  def start_date_is_before_end_date
    return if start_date.blank? || end_date.blank?
    return if end_date > start_date

    errors.add(:start_date, :greater_than_end_date)
  end
end
