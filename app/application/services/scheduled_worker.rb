# frozen_string_literal: true

require 'dry/transaction'
require 'base64'
require 'json'

module Floofloo
  module Services
    # Transaction to get news from News API
    class ScheduledWorker
      include Dry::Transaction

      step :delete_data_in_db
      step :add_news_in_db
      step :add_donation_in_db
      step :get_news_from_db
      step :get_donation_from_db
      step :add_recommendation_in_db

      private

      def delete_data_in_db(input)
        Floofloo::Services::DeleteAllRecommendations.new.call
        Floofloo::Services::DeleteAllNews.new.call
        Floofloo::Services::DeleteAllDonation.new.call
        Success(input)
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Fail to delete data in DB'))
      end

      def add_news_in_db(input)
        input[:news_list] = Floofloo::Services::AddNewsWorker.new.call(event_name: input[:event_name])
        Success(input)
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Fail to add news in DB'))
      end

      def add_donation_in_db(input)
        input[:donation_list] = Floofloo::Services::AddDonationWorker.new.call(event_name: input[:event_name])
        Success(input)
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Fail to add donation in DB'))
      end

      def get_news_from_db(input)
        input[:news_list] = Services::GetNews.new.call(event_name: input[:event_name]).value!.message.articles
        Success(input)
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :internal_error, message: e.message))
      end

      def get_donation_from_db(input)
        input[:donation_list] = Services::GetDonation.new.call(event_name: input[:event_name]).value!.message.donations
        Success(input)
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :internal_error, message: e.message))
      end

      def add_recommendation_in_db(input)
        input[:news_list].each do |news|
          input[:donation_list].each do |donation|
            Floofloo::Services::AddRecommendation.new.call(news_id: news.id, donation_id: donation.id)
          end
        end
        Success(Response::ApiResult.new(status: :ok, message: 'success'))
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :internal_error, message: e.message))
      end
    end
  end
end
