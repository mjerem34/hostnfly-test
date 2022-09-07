# frozen_string_literal: true

class Listing < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :reservations, dependent: :destroy

  validates :num_rooms, presence: true

  validates :num_rooms, numericality: { greater_than_or_equal_to: 1 }
end
