# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:news) do
      primary_key :id
      foreign_key :disease_id, :diseases

      String      :title, null: false
      String      :author
      String      :url
      String      :urlToImage

      DateTime :created_at
      DateTime :updated_at
    end
  end
end