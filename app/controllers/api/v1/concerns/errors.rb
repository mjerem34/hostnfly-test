# frozen_string_literal: true

module Api
  module V1
    module Concerns
      module Errors
        extend ActiveSupport::Concern

        included do
          rescue_from ActiveRecord::RecordNotFound do |error|
            render_json_errors(error.exception, 404)
          end

          rescue_from ActionController::ParameterMissing do |error|
            render_json_errors(error.exception, 400)
          end
        end
      end
    end
  end
end
