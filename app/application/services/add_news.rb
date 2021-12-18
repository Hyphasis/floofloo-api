# frozen_string_literal: true

require 'dry/transaction'
require 'base64'
require 'json'

module Floofloo
  module Services
    # Transaction to get news from News API
    class AddNews
      include Dry::Transaction

      step :request_add_news_worker
#      step :add_news

      private

      def request_add_news_worker(input)
        if input.empty?
          return Failure(Response::ApiResult.new(status: :internal_error, message: 'no input'))
        end
        Floofloo::Messaging::Queue.new(Floofloo::App.config.QUEUE_URL, Floofloo::App.config)
                                  .send(input.to_json)
        Success(Response::ApiResult.new(status: :ok, message: "Success"))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Background workers can not add the news'))
      end

      def add_news(input)
        unless database_empty?
          return Failure(Response::ApiResult.new(status: :internal_error, message: 'Please delete all news first'))
        end

        news = news_from_news_api(input)
        news_result = OpenStruct.new(articles: news)
        Success(Response::ApiResult.new(status: :ok, message: news_result))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Could not add the news'))
      end

      def database_empty?
        Repository::ArticlesFor.klass(Entity::News).all.empty?
      end

      def news_from_news_api(input)
        keywords = input[:event_name]
        news_result = News::NewsMapper
          .new(App.config.NEWS_KEY)
          .find(keywords, input[:from], input[:to], input[:sort_by], input[:language])

        store_news(keywords, news_result)
      rescue StandardError
        raise 'Could not find the news from News API'
      end

      def store_news(event_name, news_list)
        event = Repository::IssuesFor.entity(Entity::Event.new(id: nil, name: '')).find_name(event_name)
        news_list.articles.each do |news|
          Repository::ArticlesFor.entity(news_list).create(event, news)
        end
      rescue StandardError
        raise 'Could not store the news'
      end
    end
  end
end
