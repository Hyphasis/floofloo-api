# frozen_string_literal: true

require_relative 'spec_helper'

describe 'Test News API Library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<NEWS_KEY>') { NEWS_KEY }
    c.filter_sensitive_data('<NEWS_KEY_ESC>') { CGI.escape(NEWS_KEY) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'News Information' do
    it 'HAPPY: should provide correct news information' do
      news = Floofloo::News::NewsMapper.new(NEWS_KEY)
        .find(LANGUAGE, KEYWORDS, FROM, TO, SORT_BY)

      _(news.status).must_equal CORRECT['status']
      _(news.total_results).must_equal CORRECT['totalResults']
      _(news.author).must_equal CORRECT['author']
      _(news.title).must_equal CORRECT['title']
    end

    it 'BAD: sould raise exception when unauthorized' do
      _(proc do
        Floofloo::News::NewsMapper.new('BAD_KEY').find(LANGUAGE, KEYWORDS, FROM, TO, SORT_BY)
      end).must_raise Floofloo::News::Api::Response::Unauthorized
    end
  end
end
