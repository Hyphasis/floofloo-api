# frozen_string_literal: true

require 'dry/transaction'
require 'base64'
require 'json'

module Floofloo
  module Services
    # Transaction to get news from News API
    class AddNewsWorker
      include Dry::Transaction

      step :get_news_from_news_api
      step :store_news_in_database

      private

      def get_news_from_news_api(input)
        input[:news_list] = News::NewsMapper
          .new(App.config.NEWS_KEY)
          .find(input[:event_name], input[:from], input[:to], input[:sort_by], input[:language])
        Success(input)
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Could not get the news from News API.'))
      end

      def store_news_in_database(input)
        event = Repository::IssuesFor.entity(Entity::Event.new(id: nil, name: '')).find_name(input[:event_name])
        news_list = input[:news_list]
        news_list.articles.each do |news|
          Repository::ArticlesFor.entity(news_list).create(event, news)
        end
        Success(Response::ApiResult.new(status: :ok, message: input))
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :internal_error, message: e.message))
      end
    end
  end
end
