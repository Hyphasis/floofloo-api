# frozen_string_literal: true

require 'dry/transaction'

module Floofloo
  module Services
    # Transaction to get donation project from Global Giving API
    class AddDonationWorker
      include Dry::Transaction

      step :get_donation_projects_from_global_giving_api
      step :store_donations_in_database

      private

      def get_donation_projects_from_global_giving_api(input)
        input[:donation_list] = Donation::DonationMapper
          .new(App.config.GLOBAL_GIVING_KEY)
          .find(input[:event_name])
        Success(input)
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :internal_error, message: e.message))
      end

      def store_donations_in_database(input)
        event = Repository::IssuesFor.klass(Entity::Event).find_name(input[:event_name])
        donation_list = input[:donation_list]
        donation_list.each do |donation|
          Repository::DonationFor.entity(donation).create(event, donation)
        end
        Success(Response::ApiResult.new(status: :ok, message: input))
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :internal_error, message: e.message))
      end
    end
  end
end
