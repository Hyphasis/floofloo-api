# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:donations_events) do
      primary_key [:event_id, :donation_id] # rubocop:disable Style/SymbolArray
      foreign_key :event_id, :events
      foreign_key :donation_id, :donations

      index [:event_id, :donation_id] # rubocop:disable Style/SymbolArray
    end
  end
end
