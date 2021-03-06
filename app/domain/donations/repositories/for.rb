# frozen_string_literal: true

require_relative 'donation'

module Floofloo
  module Repository
    # Finds the right repository for an entity object or class
    module DonationFor
      ENTITY_REPOSITORY = {
        Entity::Donation => Floofloo::Repository::Donation
      }.freeze

      def self.klass(entity_klass)
        ENTITY_REPOSITORY[entity_klass]
      end

      def self.entity(entity_object)
        ENTITY_REPOSITORY[entity_object.class]
      end
    end
  end
end
