# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Floofloo
  module Entity
    # News entity
    class Donation < Dry::Struct
      include Dry.Types

      attribute :title,         Strict::String
      attribute :summary,       Strict::String
      attribute :country,       Strict::String
      attribute :city,          Strict::String
      attribute :image_url,     Strict::String
      attribute :project_url,   Strict::String

      def to_attr_hash
        to_hash.reject { |key, _| %i[id].include? key }
      end
    end
  end
end
