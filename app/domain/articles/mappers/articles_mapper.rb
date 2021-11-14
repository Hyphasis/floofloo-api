# frozen_string_literal: true

module Floofloo
  module News
    # News Mapper: NewsApi News -> News entity
    class ArticlesMapper
      def initialize(news_key, gateway_class = Floofloo::News::Api)
        @news_key = news_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@news_key)
      end

      # This method smells of :reek:UtilityFunction
      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from the data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Floofloo::Entity::Article.new(
            id: nil,
            author: author.nil? ? '' : author,
            title: title.nil? ? '' : title,
            description: description.nil? ? '' : description,
            url: url.nil? ? '' : url,
            url_to_image: url_to_image.nil? ? '' : url_to_image
          )
        end

        private

        def author
          @data['author']
        end

        def title
          @data['title']
        end

        def description
          @data['description']
        end

        def url
          @data['url']
        end

        def url_to_image
          @data['urlToImage']
        end
      end
    end
  end
end
