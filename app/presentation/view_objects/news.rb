# frozen_string_literal: true

module Views
  # View for several news
  class News
    def initialize(news)
      @news = news
    end

    def entity
      @news
    end

    def title
      @news.title
    end

    def articles
      @news.articles
    end
  end
end
