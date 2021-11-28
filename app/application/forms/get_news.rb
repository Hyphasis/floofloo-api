# frozen_string_literal: true

require 'dry-validation'

module Floofloo
  module Forms
    # Get News Form Validation
    class GetNews < Dry::Validation::Contract
      KEYWORDS = %w[flu covid polio earthquakes tsunami].freeze

      params do
        required(:language)
        required(:keywords).filled(:string)
        required(:from)
        required(:to)
        required(:sort_by)
      end

      rule(:keywords) do
        key.failure('Invalid Keyword') unless KEYWORDS.include?(value)
      end
    end
  end
end
