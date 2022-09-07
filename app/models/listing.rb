# frozen_string_literal: true

class Listing < ApplicationRecord
  validates :num_rooms, presence: true

  validates :num_rooms, numericality: { greater_than_or_equal_to: 1 }
end
