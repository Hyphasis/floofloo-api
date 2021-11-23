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
        if input.success?
          donations = donations_from_global_giving_api(input)
          Success(donations: donations)
        else
          Failure(input.errors.messages.first.to_s)
        end
      end

      def donations_from_global_giving_api(input)
        Donation::DonationMapper
          .new(App.config.GLOBAL_GIVING_KEY)
          .find(input[:keywords])
      rescue StandardError
        raise 'Could not find donation project'
      end
    end
  end
end
