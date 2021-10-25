# frozen_string_literal: true

require 'roda'
require 'slim'

module Floofloo
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt

    route do |routing| # rubocop:disable Metrics/BlockLength
      routing.assets # load CSS

      # GET /
      routing.root do
        view 'home'
      end

      routing.on 'news' do # rubocop:disable Metrics/BlockLength
        routing.is do
          # POST /news/
          routing.post do
            data = JSON.parse(routing.body.read)
            language = data['language']
            keywords = data['keywords']
            from = data['from']
            to = data['to']
            sort_by = data['sort_by']

            routing.halt 400 if keywords.nil?

            routing.redirect "/news?language=#{language}"\
                             "&keywords=#{keywords}"\
                             "&from=#{from}"\
                             "&to=#{to}"\
                             "&sort_by=#{sort_by}"
          end

          # GET /news?language={language}&keywords={keywords}&from={from}&to={to}&sort_by={sort_by}
          routing.get do
            language = routing.params['language']
            keywords = routing.params['keywords']
            from = routing.params['from']
            to = routing.params['to']
            sort_by = routing.params['sort_by']

            news = News::NewsMapper
                   .new(NEWS_KEY)
                   .find(language, keywords, from, to, sort_by)

            view 'news', locals: { news: news }
          end
        end
      end
    end
  end
end
