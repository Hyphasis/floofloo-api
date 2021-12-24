# frozen_string_literal: true

require 'dry/transaction'

module Floofloo
  module Services
    # Transaction to add recommendation
    class GetRecommendation
      include Dry::Transaction

      step :get_recommendation

      private

      def get_recommendation(input)
        if input.nil?
          Failure(Response::ApiResult.new(status: :internal_error, message: 'Could not find the recommendation'))
        else
          recommendations = recommendation_in_database(input[:news_id])
          recommendation_result = get_news_and_donations(recommendations, input[:news_id])

          Success(Response::ApiResult.new(status: :ok, message: recommendation_result))
        end
      rescue StandardError => e
        puts e.full_message
      end

      def recommendation_in_database(news_id)
        Repository::RecommendationsFor.klass(Entity::Recommendation)
          .find_by_news_id(news_id)
      end

      def get_news_and_donations(recommendations, news_id)
        news = Repository::ArticlesFor.klass(Entity::News).find_id(news_id)

        OpenStruct.new(articles: news, donations: []) if recommendations.nil?

        donations = []
        recommendations.each do |recommendation|
          donations << Repository::DonationFor.klass(Entity::Donation).find_id(recommendation.donation_id)
        end

        OpenStruct.new(articles: news, donations: donations)
      end
    end
  end
end
