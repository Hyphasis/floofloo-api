# frozen_string_literal: true

require 'dry/transaction'
require 'base64'
require 'json'

module Floofloo
  module Services
    # Transaction to get news from News API
    class AddNews
      include Dry::Transaction

      step :find_news

      private

      def find_news(input)
        if input.nil?
          Failure(Response::ApiResult.new(status: :internal_error, message: 'Could not find the news'))
        else
          news = news_from_news_api(input)
          news_result = OpenStruct.new(articles: news)

          Success(Response::ApiResult.new(status: :ok, message: news_result))
        end
      end

      def news_from_news_api(input)
        keywords = input[:event_name]

        news_result = News::NewsMapper
          .new(App.config.NEWS_KEY)
          .find(keywords, input[:from], input[:to], input[:sort_by], input[:language])

        store_news(keywords, news_result)
      rescue StandardError
        raise 'Could not find the news'
      end

      def store_news(event_name, news_list)
        event = Repository::IssuesFor.entity(Entity::Event.new(id: nil, name: '')).find_name(event_name)
        news_list.articles.each do |news|
          Repository::ArticlesFor.entity(news_list).create(event, news)
        end
      end
    end
  end
end
