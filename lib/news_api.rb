# frozen_string_literal: true

require 'http'
require_relative 'news'

module Floofloo
  # To-Be-Done
  class NewsApi
    # To-Be-Done
    module Errors
      # To-Be-Done: Only Unauthorized Error is needed right now.
    end

    # To-Be-Done: HTTP_ERROR

    def initialize(news_key)
      # To-Be-Done: Assign news_key to instance variable @news_key
    end

    def news(language, keywords, from, to, sort_by)
      # To-Be-Done: url, news_data, news
    end

    private

    def news_api_path(path, config)
      # To-Be-Done
    end

    def call_news_url(url)
      # To-Be-Done
    end

    def successful?(result)
      # To-Be-Done
    end
  end
end
