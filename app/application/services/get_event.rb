# frozen_string_literal: true

require 'dry/transaction'
require 'base64'
require 'json'

module Floofloo
  module Services
    # Transaction to get news from News API
    class GetEvent
      include Dry::Transaction

      step :find_event

      private

      def find_event
        events = event_from_database
        events_result = OpenStruct.new(events: events)

        Success(Response::ApiResult.new(status: :ok, message: events_result))
      end

      def event_from_database
        issues = Repository::IssuesFor.klass(Entity::Issue).find_all

        events = []
        issues.each do |issue|
          events_result = Repository::IssuesFor.klass(Entity::Event).find_by_issue_id(issue.id)
          events << OpenStruct.new(issue_id: issue.id, themes: events_result)
        end

        events
      end
    end
  end
end
