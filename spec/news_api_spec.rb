require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'

CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
NEWS_KEY = CONFIG['NEWS_KEY']
CORRECT = YAML.safe_load(File.read('spec/fixtures/news_results.yml'))
