# frozen_string_literal: true

module FlooFloo
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

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Disease.new(
          name: db_record.name
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_disease|
          Diseases.rebuild_entity(db_disease)
        end
      end

      def self.db_find_or_create(entity)
        Database::DiseaseOrm.find_or_create(entity.to_attr_hash)
      end

      # Helper class to persist project and its members to database
      class PersistDisease
        def initialize(entity)
          @entity = entity
        end

        def create_disease
          Database::DiseaseOrm.create(@entity.to_attr_hash)
        end

        def call
          news = News.db_find_or_create(@entity.news)

          create_disease.tap do |db_news|
            db_news.update(news: news)
          end
        end
      end
    end
  end
end
