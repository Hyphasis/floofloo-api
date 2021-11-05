# frozen_string_literal: false

module FlooFloo
  # Provides access to contributor data
  module News
    # Data Mapper: Github contributor -> Member entity
    class DiseaseMapper
      def initialize(news_key, gateway_class = Floofloo::News::Api)
        @news_key = news_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@news_key)
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Entity::Member.new(
            id: nil,
            name: name
          )
        end

        private

        def name
          @data['name']
        end
      end
    end
  end
end
