# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Integration Tests of News API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vct_for_news
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store news' do
    before do
      DatabaseHelper.wipe_database

      disease = Floofloo::Entity::Disease.new(
        id: nil,
        name: KEYWORDS
      )
      @disease = Floofloo::Repository::For.entity(disease).create(disease)
    end

    it 'HAPPY: should be able to save news from News API to database' do
      news = Floofloo::News::NewsMapper.new(NEWS_KEY).find(LANGUAGE, KEYWORDS, FROM, TO, SORT_BY)
      rebuilt = Floofloo::Repository::For.entity(news).create(@disease, news)

      _(rebuilt.disease_id).must_equal(@disease.id)
      _(rebuilt.author).must_equal(news.author)
      _(rebuilt.url).must_equal(news.url)
      _(rebuilt.url_to_image).must_equal(news.url_to_image)
    end
  end
end
