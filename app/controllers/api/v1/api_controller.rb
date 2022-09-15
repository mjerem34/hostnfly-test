# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::API
      include ::Api::V1::Concerns::Response
      include ::Api::V1::Concerns::Errors
      include ::Api::V1::Concerns::Pagination
    end
  end
end
