# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'

describe 'AddIssue Service Unit Test' do
  describe 'Add Issue in database' do
    before do
      DatabaseHelper.wipe_database
    end
    it 'HAPPY: should be able to add issue in database' do
      issue_made = Floofloo::Services::AddIssue.new.call(issue_name: ISSUE_NAME)
      _(issue_made.success?).must_equal true

      rebuilt = issue_made.value!.message
      _(rebuilt.name).must_equal(ISSUE_NAME)
    end

    it 'SAD: should not be able to add an empty issue in database' do
      issue_made = Floofloo::Services::AddIssue.new.call()
      _(issue_made.success?).must_equal false
    end
  end
end
