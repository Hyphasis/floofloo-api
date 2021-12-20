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

      def find_event(input)
        if input.nil?
          Failure(Response::ApiResult.new(status: :internal_error, message: 'Could not find the news'))
        else
          events = event_from_database(input)
          events_result = OpenStruct.new(events: events)

          Success(Response::ApiResult.new(status: :ok, message: events_result))
        end
      end

      def event_from_database(input)
        issue_name = input[:issue_name]
        issue = Repository::IssuesFor.klass(Entity::Issue).find_name(issue_name)

        Repository::IssuesFor.klass(Entity::Event).find_by_issue_id(issue.id)
      end
    end
  end
end
