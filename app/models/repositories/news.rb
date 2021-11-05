# frozen_string_literal: true

require_relative 'diseases'

module News
  module Repository
    # Repository for News Entities
    class News
      def self.all
        Database::NewsOrm.all.map { |db_news| rebuild_entity(db_news) }
      end

      def self.find(entity)
        find_origin_id(entity.origin_id)
      end

      def self.find_id(id)
        db_news = Database::NewsOrm.first(id: id)
        rebuild_entity(db_news)
      end

      def self.find_title(title)
        db_news = Database::NewsOrm.first(title: title)
        rebuild_entity(db_news)
      end

      def self.rebuild_entity(db_news)
        return nil unless db_news

        Entity::Disease.new(
          db_news.to_hash.merge(
            news: News.rebuild_many(db_news.news)
          )
        )
      end
    end
  end
end
