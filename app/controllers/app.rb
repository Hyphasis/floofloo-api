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
        news = Repository::For.klass(Entity::News).all
        view 'home', locals: { news: news }
      end
      routing.on 'disease' do # ruboco:disable Metrics/BlockLength
        routing.on do |disease_name| # ruboco:disable Metrics/BlockLength
          routing.on 'news' do # ruboco:disable Metrics/BlockLength
            routing.is do # ruboco:disable Metrics/BlockLength
              # POST /disease/{disease_name}/news
              routing.post do
                language = routing.params['language']
                keywords = routing.params['keywords']
                from = routing.params['from']
                to = routing.params['to']
                sort_by = routing.params['sort_by']

                routing.halt 400 if keywords.nil?
            

                # Get news from News
                news = News::NewsMapper
                  .new(App.config.NEWS_KEY)
                  .find(language, keywords, from, to, sort_by)
                disease = Floofloo::Entity::Disease.new(
                  name: disease_name
                )

                # Add news to database
                Repository::For.entity(disease).create(disease)
                Repository::For.entity(news).create(news)
              
                # Redirect viewer to news page but we did not have that redirect before
                routing.redirect "/disease/#{disease_name}/news/#{news.title}"
              end

              routing.get do
                # GET /disease/{disease_name}/news/{news_title}
                routing.get do |news_title|
                  news = Repository::For.klass(Entity::News)
                    .find_title(news_title)

                  # Show viewer the news
                  view 'news', locals: { news: news }
                end

                # GET /disease/{disease_id}/news?language={language}&keywords={keywords}&from={from}&to={to}&sort_by={sort_by}
                routing.is do
                  language = routing.params['language']
                  keywords = routing.params['keywords']
                  from = routing.params['from']
                  to = routing.params['to']
                  sort_by = routing.params['sort_by']

                  news = News::NewsMapper
                    .new(NEWS_KEY)
                    .find(language, keywords, from, to, sort_by)

                  # Show viewer the news
                  view 'news', locals: { news: news }
                end
              end
            end
          end
        end
      end
    end
  end
end
