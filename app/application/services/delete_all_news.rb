# frozen_string_literal: true

require 'dry/transaction'
require 'base64'
require 'json'

module Floofloo
  module Services
    # Transaction to get news from News API
    class DeleteAllNews
      include Dry::Transaction

      step :delete_all_news

      private

      def delete_all_news
        news = delete_from_database
        news_result = OpenStruct.new(articles: news)

        Success(Response::ApiResult.new(status: :ok, message: news_result))
      end

      def delete_from_database
        Repository::ArticlesFor.klass(Entity::News).delete_all
      end
    end
  end
end
