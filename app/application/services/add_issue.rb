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
        if input.success?
          issue_name = input.value!['issue']
          issue = find_issue(issue_name)
          issue = create_issue(issue_name) if issue.nil?

          Success(Response::ApiResult.new(status: :ok, message: issue))
        else
          Failure(Response::ApiResult.new(status: :internal_error, message: 'Could not find the issue'))
        end
      end

      def find_issue(issue_name)
        Repository::IssuesFor.entity(Entity::Issue.new(id: nil, name: '')).find_name(issue_name)
      end

      def create_issue(issue_name)
        binding.irb
        issue = Floofloo::Entity::Issue.new(
          id: nil,
          name: issue_name
        )

        Repository::IssuesFor.entity(Entity::Issue.new(id: nil, name: '')).create(issue)
      end
    end
  end
end
