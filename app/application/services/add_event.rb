# frozen_string_literal: true

require 'dry/transaction'
require 'base64'
require 'json'

module Floofloo
  module Services
    # Transaction to get news from News API
    class AddEvent
      include Dry::Transaction

      step :add_event

      private

      def add_event(input)
        if input.nil?
          Failure(Response::ApiResult.new(status: :internal_error, message: 'Could not add the event'))
        else
          issue = find_issue(input[:issue_name])

          event_name = input[:event_name]
          event = find_event(event_name)
          event = create_event(issue, event_name) if event.nil?

          Success(Response::ApiResult.new(status: :ok, message: event))
        end
      end

      def find_issue(issue_name)
        Repository::IssuesFor.entity(Entity::Issue.new(id: nil, name: '')).find_name(issue_name)
      end

      def find_event(event_name)
        Repository::IssuesFor.entity(Entity::Event.new(id: nil, name: '')).find_name(event_name)
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
