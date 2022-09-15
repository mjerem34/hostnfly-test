# frozen_string_literal: true

FactoryBot.define do
  factory :mission do
    mission_type { 'first_checkin' }
    price { 10 }
  end
end
