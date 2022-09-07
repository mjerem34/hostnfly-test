# frozen_string_literal: true

FactoryBot.define do
  factory :listing do
    num_rooms { generate(:num_rooms) }
  end
end
