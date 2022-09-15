# frozen_string_literal: true

class Mission < ApplicationRecord
  enum mission_type: { first_checkin: 0, last_checkout: 1, checkout_checkin: 2 }

  belongs_to :listing

  validates :date, :mission_type, :price, presence: true
end
