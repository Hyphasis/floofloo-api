# frozen_string_literal: true

module Floofloo
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

      def self.find_event_id(event_id)
        Database::NewsOrm.where(event_id: event_id).all
      end

      def self.find_title(title)
        db_news = Database::NewsOrm.first(title: title)
        rebuild_entity(db_news)
      end

      def self.create(event, entity)
        event.add_news(rebuild_entity(entity))
      end

      def self.rebuild_entity(db_news)
        return nil unless db_news

        Database::NewsOrm.new(
          title: db_news.title,
          author: db_news.author,
          description: db_news.description,
          url: db_news.url,
          url_to_image: db_news.url_to_image
        )
      end
    end
  end
end
