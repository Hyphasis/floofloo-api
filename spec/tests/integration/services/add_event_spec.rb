# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'AddEvent Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_news(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end
  describe 'Store and find event' do
    before do
      DatabaseHelper.wipe_database
      @issue = Floofloo::Services::AddIssue.new.call(issue_name: ISSUE_NAME)
    end
    it 'HAPPY: should be able to save event in database' do
      event_made = Floofloo::Services::AddEvent.new.call(issue_name: ISSUE_NAME, event_name: EVENT_NAME)
      _(event_made.success?).must_equal true
    end

    it 'SAD: should not be able to save empty event in database' do
      event_made = Floofloo::Services::AddEvent.new.call()
      _(event_made.success?).must_equal false
    end
  end
end
