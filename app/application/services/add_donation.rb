# frozen_string_literal: true

require 'dry/transaction'

module Floofloo
  module Services
    # Transaction to get donation project from Global Giving API
    class AddDonation
      include Dry::Transaction

      step :add_donations

      private

      def add_donations(input)
        unless database_empty?
          return Failure(Response::ApiResult.new(status: :internal_error, message: 'Please delete all donations first'))
        end

        donations = donations_from_global_giving_api(input)
        donations_result = OpenStruct.new(donations: donations)
        Success(Response::ApiResult.new(status: :ok, message: donations_result))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Could not add the donations'))
      end

      def database_empty?
        Repository::DonationFor.klass(Entity::Donation).all.empty?
      end

      def donations_from_global_giving_api(input)
        keywords = input[:event_name]

        donation_result = Donation::DonationMapper
          .new(App.config.GLOBAL_GIVING_KEY)
          .find(keywords)

        store_donations(keywords, donation_result)
      rescue StandardError
        raise 'Could not find the donation'
      end

      def store_donations(event_name, donation_list)
        event = Repository::IssuesFor.klass(Entity::Event).find_name(event_name)
        donation_list.each do |donation|
          Repository::DonationFor.entity(donation).create(event, donation)
        end
      end
    end
  end
end
