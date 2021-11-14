# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:events_issues) do
      primary_key [:event_id, :issue_id] # rubocop:disable Style/SymbolArray
      foreign_key :event_id, :events
      foreign_key :issue_id, :issues

      index [:event_id, :issue_id] # rubocop:disable Style/SymbolArray
    end
  end
end
