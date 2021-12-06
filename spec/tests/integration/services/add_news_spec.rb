# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'AddNews Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_news(recording: :new_episodes)
  end

  after do
    VcrHelper.eject_vcr
  end
  describe 'Store and find News' do
    before do
      DatabaseHelper.wipe_database
      @issue = Floofloo::Services::AddIssue.new.call(issue_name: ISSUE_NAME)
      @event = Floofloo::Services::AddEvent.new.call(issue_name: ISSUE_NAME, event_name: EVENT_NAME)
    end
    it 'HAPPY: should be able to find and save news from API to database' do
      news_made = Floofloo::Services::AddNews.new.call(event_name: EVENT_NAME)
      _(news_made.success?).must_equal true
    end

    it 'SAD: should not be able to find and save news with no keywords specified from API to database' do
      news_made = Floofloo::Services::AddNews.new.call()
      _(news_made.success?).must_equal false
    end
  end
end
