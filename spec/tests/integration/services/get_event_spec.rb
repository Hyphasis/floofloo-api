# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'GetEvent Service Integration Test' do
  describe 'Add Event in database' do
    before do
      DatabaseHelper.wipe_database
      @issue = Floofloo::Services::AddIssue.new.call(issue_name: ISSUE_NAME)
      @first_event = Floofloo::Services::AddEvent.new.call(issue_name: ISSUE_NAME, event_name: 'Influenza')
      @second_event = Floofloo::Services::AddEvent.new.call(issue_name: ISSUE_NAME, event_name: 'COVID-19')
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
