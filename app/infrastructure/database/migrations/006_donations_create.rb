# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:donations) do
      primary_key :id
      foreign_key :event_id, :events

      String      :title, null: false
      String      :summary, null: false
      String      :country
      String      :city
      String      :image_url

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
