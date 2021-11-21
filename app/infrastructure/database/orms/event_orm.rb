# frozen_string_literal: true

require 'sequel'

module Floofloo
  module Database
    # Object-Relational Mapper for Events
    class EventOrm < Sequel::Model(:events)
      one_to_many :news,
                  class: :'Floofloo::Database::NewsOrm',
                  key: :event_id

      one_to_many :donations,
                  class: :'Floofloo::Database::DonationOrm',
                  key: :event_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(event_info)
        first(name: event_info[:name]) || create(event_info)
      end
    end
  end
end
