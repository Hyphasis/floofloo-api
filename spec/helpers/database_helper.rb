# frozen_string_literal: true

# Helper to clean database during test runs
module DatabaseHelper
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    Floofloo::App.DB.run('PRAGMA foreign_keys = OFF')
    Floofloo::Database::IssueOrm.map(&:destroy)
    Floofloo::Database::EventOrm.map(&:destroy)
    Floofloo::Database::NewsOrm.map(&:destroy)
    Floofloo::Database::DonationOrm.map(&:destroy)
    Floofloo::App.DB.run('PRAGMA foreign_keys = ON')
  end
end
