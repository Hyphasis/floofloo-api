# frozen_string_literal: true

require 'roda'
require 'yaml'

module Floofloo
  # Configuration for the App
  class App < Roda
    CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
    NEWS_KEY = CONFIG['NEWS_KEY']
  end
end
