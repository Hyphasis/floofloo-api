# frozen_string_literal: true

require 'dry-validation'

module Floofloo
  module Forms
    # Get Donation Form Validation
    class GetDonation < Dry::Validation::Contract
      KEYWORDS = %w[flu covid polio earthquakes tsunami].freeze

      params do
        required(:keywords).filled(:string)
      end

      rule(:keywords) do
        key.failure('Invalid Keyword') unless KEYWORDS.include?(value)
      end
    end
  end
end
