# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'
require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../../init'

LANGUAGE = 'en'
KEYWORDS = 'influenza'
FROM = '2021-10-10'
TO = '2021-10-12'
SORT_BY = 'popularity'

ISSUE_NAME = 'Disease'
EVENT_NAME = 'influenza'

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'news_api'
NEWS_KEY = Floofloo::App.config.NEWS_KEY
GLOBAL_GIVING_KEY = Floofloo::App.config.GLOBAL_GIVING_KEY
CORRECT = YAML.safe_load(File.read('spec/fixtures/news_results.yml'))

def homepage
  Floofloo::App.config.APP_HOST
end
