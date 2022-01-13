# frozen_string_literal: true

require 'dry/transaction'
require 'base64'
require 'json'

module Floofloo
  module Services
    # Transaction to get donation project from Global Giving API
    class AddDonationQueue
      include Dry::Transaction

      step :request_add_donation_worker

      private

      def request_add_donation_worker(input)
        unless database_empty?
          return Failure(Response::ApiResult.new(status: :internal_error, message: 'Database is not empty'))
        end

        Messaging::Queue.new(Floofloo::App.config.DONATION_QUEUE_URL, Floofloo::App.config).send(input.to_json)
        Success(Response::ApiResult.new(status: :ok, message: 'Succeeded to send add donation message to SQS'))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Background workers can not add the news'))
      end

      def database_empty?
        Repository::DonationFor.klass(Entity::Donation).all.empty?
      end
    end
  end
end
