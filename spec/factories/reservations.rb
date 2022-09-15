# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    start_date { Time.current }
    end_date { Time.current + 7.days }

    association :listing
  end
end
