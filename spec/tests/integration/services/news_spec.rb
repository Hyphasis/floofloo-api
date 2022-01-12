# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'News Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_news(recording: :new_episodes)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_database
      Floofloo::Services::AddIssue.new.call(issue_name: ISSUE_NAME)
      Floofloo::Services::AddEvent.new.call(issue_name: ISSUE_NAME, event_name: EVENT_NAME)
    end

    it 'HAPPY: should be able to find and save news to database' do
      news_made = Floofloo::Services::AddNewsWorker.new.call(event_name: EVENT_NAME)
      _(news_made.success?).must_equal true

      first_news = Floofloo::Database::NewsOrm.first
      rebuilt_first_news = news_made.value!.message[:news_list].articles[0]

      _(rebuilt_first_news.author).must_equal(first_news.author)
      _(rebuilt_first_news.title).must_equal(first_news.title)
      _(rebuilt_first_news.description).must_equal(first_news.description)
      _(rebuilt_first_news.url).must_equal(first_news.url)
      _(rebuilt_first_news.url_to_image).must_equal(first_news.url_to_image)
    end

    it 'SAD: should fail if no keywords are given.' do
      news_made = Floofloo::Services::AddNewsWorker.new.call()
      _(news_made.success?).must_equal false
    end
  end

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_database
      Floofloo::Services::AddIssue.new.call(issue_name: ISSUE_NAME)
      Floofloo::Services::AddEvent.new.call(issue_name: ISSUE_NAME, event_name: EVENT_NAME)
      @news_made = Floofloo::Services::AddNewsWorker.new.call(event_name: EVENT_NAME)
      @rebuilt_first_news = @news_made.value!.message[:news_list].articles[0]
    end

    it 'HAPPY: should be able to find and save news to database' do
      news_found = Floofloo::Services::GetNews.new.call(event_name: EVENT_NAME)
      _(news_found.success?).must_equal true

      found_first_news = news_found.value!.message.articles[0]
      _(found_first_news.author).must_equal(@rebuilt_first_news.author)
      _(found_first_news.title).must_equal(@rebuilt_first_news.title)
      _(found_first_news.description).must_equal(@rebuilt_first_news.description)
      _(found_first_news.url).must_equal(@rebuilt_first_news.url)
      _(found_first_news.url_to_image).must_equal(@rebuilt_first_news.url_to_image)
    end
  end
end
