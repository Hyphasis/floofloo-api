# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

module Floofloo
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css', js: 'table_row.js'

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
              rescue StandardError => e
                flash[:error] = 'Failed to get news!'
                puts e.message

                routing.redirect '/'
              end

              routing.get do # rubocop:disable Metrics/BlockLength
                # GET /event/{event_name}/news/{news_id}
                routing.on String do |news_id|
                  news = Repository::ArticlesFor.klass(Entity::News)
                    .find_id(news_id)

                  view 'news', locals: { news: news }
                rescue StandardError => e
                  flash[:error] = 'Failed to get news!'
                  puts e.message

                  routing.redirect '/'
                end

                # GET /event/{event_name}/news?language={language}&keywords={keywords}&from={from}&to={to}
                # &sort_by={sort_by}
                routing.is do
                  language = routing.params['language']
                  keywords = routing.params['keywords']
                  from = routing.params['from']
                  to = routing.params['to']
                  sort_by = routing.params['sort_by']

                  if keywords.nil? || keywords.empty?
                    flash[:error] = 'Please enter keywords'
                    routing.redirect '/'
                  end

                  session[:keywords].insert(0, keywords).uniq!

                  news = News::NewsMapper
                    .new(App.config.NEWS_KEY)
                    .find(language, keywords, from, to, sort_by)

                  view 'news', locals: { news: news }
                rescue StandardError => e
                  flash[:error] = 'Failed to get news!'
                  puts e.message

                  routing.redirect '/'
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
            rescue StandardError => e
              flash[:error] = 'Failed to get donations!'
              puts e.message

              routing.redirect '/'
            end
          end

          routing.on 'delete' do
            # GET /event/{event_name}/delete
            routing.get do
              session[:keywords].delete(event_name)

              events_session = session[:keywords]
              view 'home', locals: { events_session: events_session }
            rescue StandardError => e
              flash[:error] = 'Failed to delete event!'
              puts e.message

              routing.redirect '/'
            end
          end
        end
      end
    end
  end
end
