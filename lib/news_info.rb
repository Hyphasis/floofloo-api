# frozen_string_literal: true

require 'http'
require 'yaml'

config = YAML.safe_load(File.read('config/secrets.yml'))

# This method smells of :reek:UtilityFunction
def news_api_path(path, config)
  "https://newsapi.org/v2/#{path}&apiKey=#{config['NEWS_KEY']}"
end

# This method smells of :reek:UtilityFunction
def call_news_url(url)
  HTTP.get(url)
end

news_response = {}
news_results = {}

## Happy news result
news_url = news_api_path('everything?language=en&q=influenza&from=2021-10-10&to=2021-10-12&sortBy=popularity',
                         config)
news_response[news_url] = call_news_url(news_url)
news = news_response[news_url].parse

news_results['status'] = news['status']
# should be ok

news_results['totalResults'] = news['totalResults']
# should be 160

news_results['author'] = news['articles'][0]['author']
# should be 'The New York Times'

news_results['title'] = news['articles'][0]['title']
# should be 'Moderna and J. & J. Boosters Are Probably Coming Soon'

## Bad news result
bad_news_url = news_api_path('everything?lang=en',
                             config)
news_response[bad_news_url] = call_news_url(bad_news_url)
news_response[bad_news_url].parse

File.write('spec/fixtures/news_results.yml', news_results.to_yaml)
