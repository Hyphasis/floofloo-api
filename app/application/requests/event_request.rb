# frozen_string_literal: true

require 'base64'
require 'dry/monads/result'
require 'json'

module Floofloo
  module Request
    # Event request parser
    class EventRequest
      include Dry::Monads::Result::Mixin

      def initialize(params)
        @params = params
      end

      # Use in API to parse incoming list requests
      def call
        Success(
          @params
        )
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :bad_request,
            message: 'News not found'
          )
        )
      end
    end
  end
end
