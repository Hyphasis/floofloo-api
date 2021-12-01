# frozen_string_literal: true

require 'dry/transaction'
require 'base64'
require 'json'

module Floofloo
  module Services
    # Transaction to get news from News API
    class AddIssue
      include Dry::Transaction

      step :add_issue

      private

      def add_issue(input)
        if input.nil?
          Failure(Response::ApiResult.new(status: :internal_error, message: 'Could not find the issue'))
        else
          issue_name = input[:issue_name]
          issue = find_issue(issue_name)
          issue = create_issue(issue_name) if issue.nil?

          Success(Response::ApiResult.new(status: :ok, message: issue))
        end
      end

      def find_issue(issue_name)
        Repository::IssuesFor.klass(Entity::Issue).find_name(issue_name)
      end

      def create_issue(issue_name)
        issue = Floofloo::Entity::Issue.new(
          id: nil,
          name: issue_name
        )

        Repository::IssuesFor.entity(issue).create(issue)
      end
    end
  end
end
