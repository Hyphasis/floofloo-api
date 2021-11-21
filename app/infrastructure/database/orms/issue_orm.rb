# frozen_string_literal: true

require 'sequel'

module Floofloo
  module Database
    # Object-Relational Mapper for Issues
    class IssueOrm < Sequel::Model(:issues)
      one_to_many :events,
                  class: :'Floofloo::Database::EventOrm',
                  key: :issue_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(issue_info)
        first(name: issue_info[:name]) || create(issue_info)
      end
    end
  end
end
