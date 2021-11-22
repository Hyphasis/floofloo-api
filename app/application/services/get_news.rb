# frozen_string_literal: true

require 'dry/transaction'

module Floofloo
  module Services
    # Transaction to store project from Github API to database
    class GetNews
      include Dry::Transaction

      step :find_news

      private

      def find_news(input)
        if input.success?
          news = news_from_news_api(input)
          Success(news: news)
        else
          Failure(input.errors.messages.first.to_s)
        end
      end

      def news_from_news_api(input)
        News::NewsMapper
          .new(App.config.NEWS_KEY)
          .find(input[:language], input[:keywords], input[:from], input[:to], input[:sort_by])
      rescue StandardError
        raise 'Could not find the news'
      end
    end
  end
end
