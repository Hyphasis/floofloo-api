# frozen_string_literal: true

require 'dry/transaction'

module Floofloo
  module Services
    # Transaction to get news from News API
    class AddEvent
      include Dry::Transaction

      step :add_event

      private

      ISSUE_ERR_MSG = 'Issue not found in database'

      def add_event(input)
        issue = issue_in_database(input)
        event = event_in_database(input) || create_event(issue, input[:event_name])
        Success(Response::ApiResult.new(status: :ok, message: event))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Could not add the event'))
      end

      def issue_in_database(input)
        Repository::IssuesFor.klass(Entity::Issue).find_name(input[:issue_name])
      rescue StandardError
        raise ISSUE_ERR_MSG
      end

      def event_in_database(input)
        Repository::IssuesFor.klass(Entity::Event).find_name(input[:event_name])
      end

      def create_event(issue, event_name)
        event = Floofloo::Entity::Event.new(
          id: nil,
          name: event_name
        )

        Repository::IssuesFor.entity(event).create(issue, event)
      end
    end
  end
end
