# frozen_string_literal: true

module Floofloo
  module Repository
    # Repository for Issues
    class Recommendations
      def self.find_by_news_id(news_id)
        Database::RecommendationOrm.where(news_id: news_id).all
      end

      def self.find_by_news_id_and_donation_id(news_id, donation_id)
        Database::RecommendationOrm.where(news_id: news_id, donation_id: donation_id).first
      end

      def self.find_all
        Database::RecommendationOrm.all
      end

      def self.create(entity)
        Database::RecommendationOrm.find_or_create(entity.to_attr_hash)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Recommendation.new(
          news_id: db_record.news_id,
          donation_id: db_record.donation_id
        )
      end

      def self.delete_all
        Database::RecommendationOrm.all.map(&:delete)
      end
    end
  end
end
