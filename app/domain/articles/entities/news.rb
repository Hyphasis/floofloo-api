# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Floofloo
  module Entity
    # News entity
    class News < Dry::Struct
      include Dry.Types

      attribute :id,            Integer.optional
      attribute :status,        Strict::String
      attribute :total_results, Strict::Integer
      attribute :articles,      Array.of(Article)

      def to_attr_hash
        to_hash.reject { |key, _| %i[id].include? key }
      end
    end
  end
end
