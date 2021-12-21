# frozen_string_literal: true

module Floofloo
  module Repository
    # Repository for Events
    class Events
      def self.find_id(id)
        rebuild_entity Database::EventOrm.first(id: id)
      end

      def self.all
        Database::EventOrm.all
      end

      def self.find_all
        Database::EventOrm
          .left_join(:issues, id: :issue_id)
          .map { |db_issues| rebuild_entity(db_issues) }
      end

      def self.find_name(name)
        Database::EventOrm.first(name: name)
      end

      def self.find_by_issue_id(issue_id)
        Database::EventOrm.where(issue_id: issue_id).all
      end

      def self.create(issue, entity)
        issue.add_event(rebuild_entity(entity))
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Database::EventOrm.new(
          name: db_record.name
        )
      end
    end
  end
end
