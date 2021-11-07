# frozen_string_literal: true

require 'sequel'

module Floofloo
  module Database
    # Object-Relational Mapper for Members
    class DiseaseOrm < Sequel::Model(:diseases)
      one_to_many :news,
                  class: :'Floofloo::Database::NewsOrm',
                  key: :disease_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(disease_info)
        first(name: disease_info[:name]) || create(disease_info)
      end
    end
  end
end
