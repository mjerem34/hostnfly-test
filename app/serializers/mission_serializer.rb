# frozen_string_literal: true

class MissionSerializer < ApplicationSerializer
  attributes :listing_id,
             :mission_type,
             :date,
             :price
end
