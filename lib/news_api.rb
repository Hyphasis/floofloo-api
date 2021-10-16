# frozen_string_literal: true

require 'http'
require_relative 'news'

module Floofloo
  # Library for Github Web API
  class NewsApi
    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end # rubocop:disable Layout/EmptyLineBetweenDefs
    end

    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize(news_key)
      @news_key = news_key
    end

    def news(language, keywords, from, to, sort_by)
      news_url = news_api_path("everything?language=#{language}&q=#{keywords}&from=#{from}&to=#{to}&sortBy=#{sort_by}")
      news_data = call_news_url(news_url).parse
      News.new(news_data)
    end

    private

    def news_api_path(path)
      "https://newsapi.org/v2/#{path}&apiKey=#{@news_key}"
    end

    def call_news_url(url)
      result = HTTP.get(url)
      successful?(result) ? result : raise(HTTP_ERROR[result.code])
    end

    def successful?(result)
      !HTTP_ERROR.keys.include?(result.code)
    end
  end
end
