# frozen_string_literal: true

module Floofloo
  module News
    # News Mapper: NewsApi News -> News entity
    class NewsMapper
      def initialize(news_key, gateway_class = Floofloo::News::Api)
        @news_key = news_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@news_key)
      end

      # This method smells of :reek:LongParameterList
      def find(language, keywords, from, to, sort_by)
        data = @gateway.news(language, keywords, from, to, sort_by)
        build_entity(data)
      end

      # This method smells of :reek:UtilityFunction
      def build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from the data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Floofloo::Entity::News.new(
            id: nil,
            status: status,
            total_results: total_results,
            author: author,
            title: title,
            url: url,
            url_to_image: url_to_image
          )
        end

        private

        def status
          @data['status']
        end

        def total_results
          @data['totalResults']
        end

        def author
          @data['articles'][0]['author']
        end

        def title
          @data['articles'][0]['title']
        end

        def url
          @data['articles'][0]['url']
        end

        def url_to_image
          @data['articles'][0]['urlToImage']
        end
      end
    end
  end
end
