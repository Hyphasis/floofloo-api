# frozen_string_literal: true

require_relative 'news'

module Floofloo
  module Repository
    # Finds the right repository for an entity object or class
    module ArticlesFor
      ENTITY_REPOSITORY = {
        Entity::News => Floofloo::Repository::News
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
