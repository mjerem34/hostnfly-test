# frozen_string_literal: true

module Api
  module V1
    module Concerns
      module Response
        extend ActiveSupport::Concern

        # https://github.com/rails/rails/issues/23923
        def render_json(object, status = 200)
          render plain: object.to_json, content_type: 'application/json', status: status
        end

        def render_json_errors(errors, status = 400)
          render plain: { errors: Array.wrap(errors) }.to_json,
                 content_type: 'application/json', status: status
        end
      end
    end
  end
end
