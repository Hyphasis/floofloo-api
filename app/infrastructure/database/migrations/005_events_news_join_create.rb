# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:events_news) do
      primary_key [:event_id, :news_id] # rubocop:disable Style/SymbolArray
      foreign_key :event_id, :events
      foreign_key :news_id, :news

      index [:event_id, :news_id] # rubocop:disable Style/SymbolArray
    end
  end
end
