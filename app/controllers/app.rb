# frozen_string_literal: true

require 'roda'
require 'slim'

module Floofloo
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt
    plugin :all_verbs
    plugin :flash

    route do |routing| # rubocop:disable Metrics/BlockLength
      routing.assets # load CSS

      # GET /
      routing.root do
        session[:keywords] ||= []
        events_session = session[:keywords]

        view 'home', locals: { events_session: events_session }
      end

      routing.on 'event' do # rubocop:disable Metrics/BlockLength
        routing.on String do |event_name| # rubocop:disable Metrics/BlockLength
          routing.on 'news' do # rubocop:disable Metrics/BlockLength
            routing.is do # rubocop:disable Metrics/BlockLength
              # POST /event/{event_name}/news
              routing.post do
                language = routing.params['language']
                keywords = routing.params['keywords']
                from = routing.params['from']
                to = routing.params['to']
                sort_by = routing.params['sort_by']

                routing.halt 400 if keywords.nil?

                event = Floofloo::Entity::Event.new(
                  id: nil,
                  name: event_name
                )
                event_result = Repository::IssuesFor.entity(event).create(event)

                # Get news from News
                news = News::NewsMapper
                  .new(App.config.NEWS_KEY)
                  .find(language, keywords, from, to, sort_by)
                news_result = Repository::ArticlesFor.entity(news).create(event_result, news)

                # Put the news on screen (Home page)
                routing.redirect "/event/#{event_name}/news/#{news_result.id}"
              end

              routing.get do
                # GET /event/{event_name}/news/{news_id}
                routing.on String do |news_id|
                  news = Repository::ArticlesFor.klass(Entity::News)
                    .find_id(news_id)

                  view 'news', locals: { news: news }
                end

                # GET /event/{event_name}/news?language={language}&keywords={keywords}&from={from}&to={to}
                # &sort_by={sort_by}
                routing.is do
                  language = routing.params['language']
                  keywords = routing.params['keywords']
                  from = routing.params['from']
                  to = routing.params['to']
                  sort_by = routing.params['sort_by']

                  session[:keywords].insert(0, keywords).uniq!

                  news = News::NewsMapper
                    .new(App.config.NEWS_KEY)
                    .find(language, keywords, from, to, sort_by)

                  view 'news', locals: { news: news }
                end
              end
            end
          end

          routing.on 'donations' do
            # GET /event/{event_name}/donations?keywords={keywords}
            routing.is do
              keywords = routing.params['keywords']

              donations = Donation::DonationMapper
                .new(App.config.GLOBAL_GIVING_KEY)
                .find(keywords)

              view 'donations', locals: { donations: donations }
            end
          end

          routing.on 'delete' do
            # GET /event/{event_name}
            routing.get do
              session[:keywords].delete(event_name)

              events_session = session[:keywords]
              view 'home', locals: { events_session: events_session }
            end
          end
        end
      end
    end
  end
end
