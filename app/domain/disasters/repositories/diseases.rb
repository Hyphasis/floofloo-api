# frozen_string_literal: true

module Floofloo
  module Repository
    # Repository for Members
    class Diseases
      def self.find_id(id)
        rebuild_entity Database::DiseaseOrm.first(id: id)
      end

      def self.find_all(name)
        db_disease = Database::DiseaseOrm
          .left_join(:news, id: :disease_id)
          .where(name: name)
          .first
        rebuild_entity(db_disease)
      end

      def self.find_name(name)
        rebuild_entity Database::DiseaseOrm.first(name: name)
      end

      def self.create(entity)
        Database::DiseaseOrm.find_or_create(entity.to_attr_hash)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Disease.new(
          name: db_record.name
        )
      end
    end
  end
end
