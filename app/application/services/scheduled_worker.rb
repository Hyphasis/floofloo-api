# frozen_string_literal: true

require 'dry/transaction'
require 'base64'
require 'json'

module Floofloo
  module Services
    # Transaction to add recommendations of news and donation projects
    class ScheduledWorker
      include Dry::Transaction

      step :delete_data_in_database
      step :get_event_names
      step :add_news
      step :add_donation
      step :get_news
      step :add_recommendation

      private

      def delete_data_in_database(input)
        Floofloo::Services::DeleteAllRecommendations.new.call
        Floofloo::Services::DeleteAllNews.new.call
        Floofloo::Services::DeleteAllDonation.new.call
        Success(input)
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Fail to delete data in the database.'))
      end

      def get_event_names(input)
        find_events = Services::GetEvent.new.call.value!.message.events
        input[:event_names] = []
        find_events.each do |event|
          event.themes.each do |event_name|
            input[:event_names].append(event_name[:name])
          end
        end
        Success(input)
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Fail to get event names.'))
      end

      def add_news(input)
        event_names = input[:event_names]
        event_names.each do |event_name|
          Floofloo::Services::AddNewsWorker.new.call(event_name: event_name)
        end
        Success(input)
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Fail to add news in database.'))
      end

      def add_donation(input)
        event_names = input[:event_names]
        event_names.each do |event_name|
          Floofloo::Services::AddDonationWorker.new.call(event_name: event_name)
        end
        Success(input)
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Fail to add donation in database.'))
      end

      def get_news(input)
        input[:news_list] = Floofloo::Database::NewsOrm.all
        Success(input)
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :internal_error, message: e.message))
      end

      def add_recommendation(input)
        input[:news_list].each do |news|
          donation_list = Repository::DonationFor.klass(Entity::Donation).find_event_id(news.event_id)
          donation_list.each do |donation|
            Services::AddRecommendation.new.call(news_id: news.id, donation_id: donation.id)
          end
        end
        Success(Response::ApiResult.new(status: :ok, message: 'Succeed to add recommendations.'))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Fail to add recommendations'))
      end
    end
  end
end
