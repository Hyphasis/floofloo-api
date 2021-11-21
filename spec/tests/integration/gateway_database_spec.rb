# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'

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

      issue = Floofloo::Entity::Issue.new(
        id: nil,
        name: KEYWORDS
      )
      Floofloo::Repository::IssuesFor.entity(issue).create(issue)
      @issue = Floofloo::Database::IssueOrm.first

      event = Floofloo::Entity::Event.new(
        id: nil,
        name: KEYWORDS
      )
      @event = Floofloo::Repository::IssuesFor.entity(event).create(@issue, event)
    end

    it 'HAPPY: should be able to save news from News API to database' do
      news = Floofloo::News::NewsMapper.new(NEWS_KEY).find(LANGUAGE, KEYWORDS, FROM, TO, SORT_BY)

      rebuilt = Floofloo::Repository::ArticlesFor.entity(news).create(@event, news.articles[0])

      _(rebuilt.event_id).must_equal(@event.id)
      _(rebuilt.author).must_equal(news.articles[0].author)
      _(rebuilt.url).must_equal(news.articles[0].url)
      _(rebuilt.url_to_image).must_equal(news.articles[0].url_to_image)
    end
  end
end
