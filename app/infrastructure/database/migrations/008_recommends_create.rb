# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:recommends) do
      primary_key :id

      Integer     :news_id, null: false
      Integer     :donation_id, null: false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
