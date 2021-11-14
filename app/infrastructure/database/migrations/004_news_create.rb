# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:news) do
      primary_key :id
      foreign_key :event_id, :events

      String      :title, null: false
      String      :author
      String      :description, null: false
      String      :url
      String      :url_to_image

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
