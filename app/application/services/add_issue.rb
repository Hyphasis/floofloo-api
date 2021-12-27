# frozen_string_literal: true

require 'dry/transaction'

module Floofloo
  module Services
    # Transaction to get news from News API
    class AddIssue
      include Dry::Transaction

      step :add_issue

      private

      ISSUE_DB_ERR_MSG = 'Having trouble accessing the database while adding the issue.'

      def add_issue(input)
        issue = issue_in_database?(input) || create_issue_in_database(input)
        Success(Response::ApiResult.new(status: :ok, message: issue))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: ISSUE_DB_ERR_MSG))
      end

      def issue_in_database?(input)
        Repository::IssuesFor.klass(Entity::Issue).find_name(input[:issue_name])
      end

      def create_issue_in_database(input)
        issue = Floofloo::Entity::Issue.new(
          id: nil,
          name: input[:issue_name]
        )
        Repository::IssuesFor.entity(issue).create(issue)
      end
    end
  end
end
