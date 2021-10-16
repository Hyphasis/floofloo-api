# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/news_api'

CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
NEWS_KEY = CONFIG['NEWS_KEY']
CORRECT = YAML.safe_load(File.read('spec/fixtures/news_results.yml'))

LANGUAGE = 'en'
KEYWORDS = 'influenza'
FROM = '2021-10-10'
TO = '2021-10-12'
SORT_BY = 'popularity'

describe 'Test News API Library' do
  describe 'News Information' do
    it 'HAPPY: should provide correct news information' do
      news = Floofloo::NewsApi.new(NEWS_KEY)
                              .news(LANGUAGE, KEYWORDS, FROM, TO, SORT_BY)
      _(news.status).must_equal CORRECT['status']
      _(news.total_results).must_equal CORRECT['totalResults']
      _(news.author).must_equal CORRECT['author']
      _(news.title).must_equal CORRECT['title']
    end

    it 'BAD: sould raise exception when unauthorized' do
      _(proc do
        Floofloo::NewsApi.new('BAD_KEY').news(LANGUAGE, KEYWORDS, FROM, TO, SORT_BY)
      end).must_raise Floofloo::NewsApi::Errors::Unauthorized
    end
  end
end
