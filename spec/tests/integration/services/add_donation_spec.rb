# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'AddDonation Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_donation(recording: :new_episodes)
  end

  after do
    VcrHelper.eject_vcr
  end
  describe 'Store and find Donation' do
    before do
      DatabaseHelper.wipe_database
      @issue = Floofloo::Services::AddIssue.new.call(issue_name: ISSUE_NAME)
      @event = Floofloo::Services::AddEvent.new.call(issue_name: ISSUE_NAME, event_name: EVENT_NAME)
    end
    it 'HAPPY: should be able to find and save Donation from API to database' do
      donation_made = Floofloo::Services::AddDonation.new.call(event_name: EVENT_NAME)
      _(donation_made.success?).must_equal true
    end

    it 'SAD: should not be able to find and save Donation with no keywords specified from API to database' do
      donation_made = Floofloo::Services::AddDonation.new.call()
      _(donation_made.success?).must_equal false
    end
  end
end
