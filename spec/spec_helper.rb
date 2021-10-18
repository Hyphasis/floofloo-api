# frozen_string_literal: true

require 'yaml'
require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../lib/news_api'

CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
NEWS_KEY = CONFIG['NEWS_KEY']
CORRECT = YAML.safe_load(File.read('spec/fixtures/news_results.yml'))

LANGUAGE = 'en'
KEYWORDS = 'influenza'
FROM = '2021-10-10'
TO = '2021-10-12'
SORT_BY = 'popularity'

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'news_api'
