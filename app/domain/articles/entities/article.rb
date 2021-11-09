# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Floofloo
  module Entity
    # News entity
    class Article < Dry::Struct
      include Dry.Types

      attribute :author,        Strict::String.optional
      attribute :title,         Strict::String
      attribute :url,           Strict::String
      attribute :url_to_image,  Strict::String

      def to_attr_hash
        to_hash.reject { |key, _| %i[id].include? key }
      end
    end
  end
end
