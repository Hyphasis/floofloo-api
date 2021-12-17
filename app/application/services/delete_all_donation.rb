# frozen_string_literal: true

require 'dry/transaction'

module Floofloo
  module Services
    # Transaction to get donation project from Global Giving API
    class DeleteAllDonation
      include Dry::Transaction

      step :delete_all_donations

      private

      def delete_all_donations
        donations = delete_from_database
        donations_result = OpenStruct.new(donations: donations)

        Success(Response::ApiResult.new(status: :ok, message: donations_result))
      end

      def delete_from_database
        Repository::DonationFor.klass(Entity::Donation).delete_all
      end
    end
  end
end
