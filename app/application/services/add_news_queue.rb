# frozen_string_literal: true

require 'dry/transaction'
require 'base64'
require 'json'

module Floofloo
  module Services
    # Transaction to get news from News API
    class AddNewsQueue
      include Dry::Transaction

      step :request_add_news_worker

      private

      def request_add_news_worker(input)
        unless database_empty?
          return Failure(Response::ApiResult.new(status: :internal_error, message: 'Database is not empty'))
        end

        Messaging::Queue.new(Floofloo::App.config.QUEUE_URL, Floofloo::App.config).send(input.to_json)
        Success(Response::ApiResult.new(status: :ok, message: 'Succeeded to send add news message to SQS'))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Background workers can not add the news'))
      end

      def database_empty?
        Repository::ArticlesFor.klass(Entity::News).all.empty?
      end
    end
  end
end
