# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'helpers/database_helper'

describe 'Test Disease Database' do
  before do
    DatabaseHelper.wipe_database
  end

  it 'HAPPY: should be able to save disease in database' do
    disease = Floofloo::Entity::Disease.new(
      id: nil,
      name: KEYWORDS
    )
    @disease = Floofloo::Repository::For.entity(disease).create(disease)
    _(disease.name).must_equal(@disease.name)
  end
end
