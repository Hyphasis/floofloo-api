# frozen_string_literal: true

# Helper to clean database during test runs
module DatabaseHelper
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    Floofloo::App.DB.run('PRAGMA foreign_keys = OFF')
    # Floofloo::Database::MemberOrm.map(&:destroy)
    # Floofloo::Database::ProjectOrm.map(&:destroy)
    Floofloo::App.DB.run('PRAGMA foreign_keys = ON')
  end
end