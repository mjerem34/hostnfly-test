# frozen_string_literal: true

module Api
  module V1
    class MissionsController < ApiController
      def index
        render_json paginate(MissionSerializer, Mission.all.order(:listing_id, :date))
      end
    end
  end
end
