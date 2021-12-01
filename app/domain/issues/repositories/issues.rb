# frozen_string_literal: true

module Floofloo
  module Repository
    # Repository for Issues
    class Issues
      def self.find_id(id)
        rebuild_entity Database::IssueOrm.first(id: id)
      end

      def self.find_all
        Database::IssueOrm.all.map { |db_issues| rebuild_entity(db_issues) }
      end

      def self.find_name(name)
        Database::IssueOrm.first(name: name)
      end

      def self.create(entity)
        Database::IssueOrm.find_or_create(entity.to_attr_hash)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Issue.new(
          name: db_record.name
        )
      end
    end
  end
end
