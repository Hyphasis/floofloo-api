# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'AddEvent Service Integration Test' do
  describe 'Add Event in database' do
    before do
      DatabaseHelper.wipe_database
      @issue = Floofloo::Services::AddIssue.new.call(issue_name: ISSUE_NAME)
    end
    it 'HAPPY: should be able to add event in database' do
      event_made = Floofloo::Services::AddEvent.new.call(issue_name: ISSUE_NAME, event_name: EVENT_NAME)
      _(event_made.success?).must_equal true
      rebuilt = event_made.value!.message
      _(rebuilt.name).must_equal(EVENT_NAME)
    end

    it 'SAD: should not be able to add an empty event in database' do
      event_made = Floofloo::Services::AddEvent.new.call()
      _(event_made.success?).must_equal false
    end

    it 'SAD: should not be able to add an event under inexistent issue' do
      event_made = Floofloo::Services::AddEvent.new.call(issue_name: 'Inexistent Issue', event_name: EVENT_NAME)
      _(event_made.success?).must_equal false
    end
  end
end

describe 'GetEvent Service Integration Test' do
  describe 'Add Event in database' do
    before do
      DatabaseHelper.wipe_database
      @issue = Floofloo::Services::AddIssue.new.call(issue_name: ISSUE_NAME)
      Floofloo::Services::AddEvent.new.call(issue_name: ISSUE_NAME, event_name: 'Influenza')
      Floofloo::Services::AddEvent.new.call(issue_name: ISSUE_NAME, event_name: 'COVID-19')
    end
    it 'HAPPY: should be able to get event in database' do
      event_made = Floofloo::Services::GetEvent.new.call
      _(event_made.success?).must_equal true
      rebuilt = event_made.value!.message
      _(rebuilt.events[0].themes[0].name).must_equal('Influenza')
      _(rebuilt.events[0].themes[1].name).must_equal('COVID-19')
    end
  end
end
