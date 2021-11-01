# frozen_string_literal: true

require 'sequel'

module Floofloo
  module Database
    # Object Relational Mapper for Project Entities
    class NewsOrm < Sequel::Model(:news)
      many_to_one :disease,
                  class: :'Floofloo::Database::DiseaseOrm'

      plugin :timestamps, update_on_create: true

      def self.find_or_create(news_info)
        first(title: news_info[:title]) || create(news_info)
      end
    end
  end
end
