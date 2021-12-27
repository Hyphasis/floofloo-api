# frozen_string_literal: true

require 'sequel'

module Floofloo
  module Database
    # Object-Relational Mapper for Recommendation
    class RecommendationOrm < Sequel::Model(:recommends)
      plugin :timestamps, update_on_create: true

      def self.find_or_create(recommemdation_info)
        first(news_id: recommemdation_info[:news_id], donation_id: recommemdation_info[:donation_id]) ||
          create(recommemdation_info)
      end
    end
  end
end
