# frozen_string_literal: true

require 'dry/transaction'

module Floofloo
  module Services
    # Transaction to add recommendation
    class AddRecommendation
      include Dry::Transaction

      step :add_recommendation

      private

      def add_recommendation(input)
        news_id = input[:news_id]
        donation_id = input[:donation_id]

        recommendation_in_database(news_id, donation_id) ||
          create_recommendation_in_database(news_id, donation_id)

        Success(OpenStruct.new(message: 'Succeeded to add recommendation'))
      rescue StandardError => e
        Failure(OpenStruct.new(message: 'Failed to add recommendation'))
        puts e.full_message
      end

      def recommendation_in_database(news_id, donation_id)
        Repository::RecommendationsFor.klass(Entity::Recommendation)
          .find_by_news_id_and_donation_id(news_id, donation_id)
      end

      def create_recommendation_in_database(news_id, donation_id)
        recommendation = Floofloo::Entity::Recommendation.new(
          id: nil,
          news_id: news_id,
          donation_id: donation_id
        )
        Repository::RecommendationsFor.klass(Entity::Recommendation).create(recommendation)
      end
    end
  end
end
