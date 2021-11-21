# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/database_helper'

describe 'Test Issue Database' do
  before do
    DatabaseHelper.wipe_database
  end

  it 'HAPPY: should be able to save issue in database' do
    issue = Floofloo::Entity::Issue.new(
      id: nil,
      name: KEYWORDS
    )

    @issue = Floofloo::Repository::IssuesFor.entity(issue).create(issue)
    _(issue.name).must_equal(@issue.name)
  end
end
