# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Floofloo
  module Entity
    # Disease entity
    class Disease < Dry::Struct
      include Dry.Types

      attribute :id,   Integer.optional
      attribute :name, Strict::String

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
