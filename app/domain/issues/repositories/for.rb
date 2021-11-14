# frozen_string_literal: true

require_relative 'events'
require_relative 'issues'

module Floofloo
  module Repository
    # Finds the right repository for an entity object or class
    module IssuesFor
      ENTITY_REPOSITORY = {
        Entity::Issue => Floofloo::Repository::Issues,
        Entity::Event => Floofloo::Repository::Events
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
