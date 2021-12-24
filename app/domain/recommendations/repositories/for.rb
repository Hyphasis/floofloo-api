# frozen_string_literal: true

require_relative 'recommendations'

module Floofloo
  module Repository
    # Finds the right repository for an entity object or class
    module RecommendationsFor
      ENTITY_REPOSITORY = {
        Entity::Recommendation => Floofloo::Repository::Recommendations
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
