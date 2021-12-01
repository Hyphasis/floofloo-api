# frozen_string_literal: true

require 'dry/transaction'

module Floofloo
  module Services
    # Transaction to get donation project from Global Giving API
    class GetDonation
      include Dry::Transaction

      step :find_donations

      private

      def find_donations(input)
        if input.nil?
          Failure(Response::ApiResult.new(status: :internal_error, message: 'Could not find the donations'))
        else
          donations = donations_from_database(input)
          donations_result = OpenStruct.new(donations: donations)

          Success(Response::ApiResult.new(status: :ok, message: donations_result))
        end
      end

      def donations_from_database(input)
        event_name = input[:event_name]
        event = Repository::IssuesFor.klass(Entity::Event).find_name(event_name)

        Repository::DonationFor.klass(Entity::Donation).find_event_id(event.id)
      end
    end
  end
end
