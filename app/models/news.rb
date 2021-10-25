# frozen_string_literal: true

module Floofloo
  # Model for News
  class News
    def initialize(news_data)
      @news = news_data
    end

    def status
      @news['status']
    end

    def total_results
      @news['totalResults']
    end

    def author
      @news['articles'][0]['author']
    end

    def title
      @news['articles'][0]['title']
    end
  end
end
