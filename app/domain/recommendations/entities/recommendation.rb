# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Floofloo
  module Entity
    # Event entity (Sub catrgory of Issue)
    class Recommendation < Dry::Struct
      include Dry.Types

      attribute :news_id, Integer.optional
      attribute :donation_id, Integer.optional

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
