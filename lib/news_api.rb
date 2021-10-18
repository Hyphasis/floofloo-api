# frozen_string_literal: true

require 'http'
require_relative 'news'

module Floofloo
  # Library for Github Web API
  class NewsApi
    NEWS_PATH = 'https://newsapi.org/v2/'

    def initialize(news_key)
      @news_key = news_key
    end

    # This method smells of :reek:LongParameterList
    def news(language, keywords, from, to, sort_by)
      news_response = Request.new(NEWS_PATH, @news_key)
                             .news(language, keywords, from, to, sort_by).parse
      News.new(news_response)
    end

    # Send out HTTP request to News API
    class Request
      def initialize(resource_root, key)
        @resource_root = resource_root
        @key = key
      end

      # This method smells of :reek:LongParameterList
      def news(language, keywords, from, to, sort_by)
        news_url = "#{@resource_root}everything?"\
                   "language=#{language}&q=#{keywords}&from=#{from}&to=#{to}&sortBy=#{sort_by}"\
                   "&apiKey=#{@key}"
        get(news_url)
      end

      # This method smells of :reek:FeatureEnvy
      def get(url)
        http_response = HTTP.get(url)

        Response.new(http_response).tap do |response|
          raise(response.error) unless response.successful?
        end
      end
    end

    # Decorate HTTP responses from News API with success/error reporting
    class Response < SimpleDelegator
      # NotFound Error
      NotFound = Class.new(StandardError)

      # Unauthorized Error
      Unauthorized = Class.new(StandardError)

      HTTP_ERROR = {
        401 => Unauthorized,
        404 => NotFound
      }.freeze

      def successful?
        !HTTP_ERROR.keys.include?(code)
      end

      def error
        HTTP_ERROR[code]
      end
    end
  end
end
