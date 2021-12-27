# frozen_string_literal: true

require 'dry/transaction'
require 'base64'
require 'json'

module Floofloo
  module Services
    # Delete all the recommendations in database
    class DeleteAllRecommendations
      include Dry::Transaction

      step :delete_all_recommendation

      private

      def delete_all_recommendation
        recommendations = delete_from_database
        recommendations_result = OpenStruct.new(recommendations: recommendations)

        Success(Response::ApiResult.new(status: :ok, message: recommendations_result))
      end

      def delete_from_database
        Repository::RecommendationsFor.klass(Entity::Recommendation).delete_all
      end
    end
  end
end
