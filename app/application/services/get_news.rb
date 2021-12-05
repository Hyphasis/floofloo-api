# frozen_string_literal: true

require 'dry/transaction'
require 'base64'
require 'json'

module Floofloo
  module Services
    # Transaction to get news from News API
    class GetNews
      include Dry::Transaction

      step :find_news

      private

      def find_news(input)
        if input.nil?
          Failure(Response::ApiResult.new(status: :internal_error, message: 'Could not find the news'))
        else
          news = news_from_database(input)
          news_result = OpenStruct.new(articles: news)

          Success(Response::ApiResult.new(status: :ok, message: news_result))
        end
      end

      def news_from_database(input)
        event_name = input[:event_name]
        event = Repository::IssuesFor.entity(Entity::Event.new(id: nil, name: '')).find_name(event_name)

        Repository::ArticlesFor.klass(Entity::News).find_event_id(event.id)
      end
    end
  end
end
