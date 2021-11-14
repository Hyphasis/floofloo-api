# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:events) do
      primary_key :id
      foreign_key :issue_id, :issues

      String      :name, null: false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
