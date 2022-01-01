# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

module Floofloo
  # Web App
  class App < Roda # rubocop:disable Metrics/ClassLength
    plugin :halt
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :caching
    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    route do |routing| # rubocop:disable Metrics/BlockLength
      # GET /
      routing.root do
        message = "Floofloo API v1 at /api/v1/ in #{App.environment} mode"

        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'api/v1' do # rubocop:disable Metrics/BlockLength
        routing.on 'issue' do # rubocop:disable Metrics/BlockLength
          routing.on String do |issue_name| # rubocop:disable Metrics/BlockLength
            routing.on 'event' do # rubocop:disable Metrics/BlockLength
              routing.on String do |event_name| # rubocop:disable Metrics/BlockLength
                routing.on 'news' do # rubocop:disable Metrics/BlockLength
                  # GET /api/v1/issue/{issue_name}/event/{event_name}/news
                  routing.get do
                    response.cache_control public: true, max_age: 300
                    find_news = Services::GetNews.new.call(event_name: event_name)

                    if find_news.failure?
                      failed = Representer::HttpResponse.new(find_news.failure)
                      routing.halt failed.http_status_code, failed.to_json
                    end

                    http_response = Representer::HttpResponse.new(find_news.value!)
                    response.status = http_response.http_status_code

                    Representer::NewsList.new(find_news.value!.message).to_json
                  rescue StandardError => e
                    puts e.full_message

                    routing.redirect '/'
                  end

                  # POST /api/v1/issue/{issue_name}/event/{event_name}/news
                  routing.post do
                    add_news = Services::AddNewsQueue.new.call(event_name: event_name)

                    if add_news.failure?
                      failed = Representer::HttpResponse.new(add_news.failure)
                      routing.halt failed.http_status_code, failed.to_json
                    end

                    http_response = Representer::HttpResponse.new(add_news.value!)
                    response.status = http_response.http_status_code

                    add_news.value!.message.to_json
                  rescue StandardError => e
                    puts e.full_message

                    routing.redirect '/'
                  end
                end

                routing.on 'donations' do # rubocop:disable Metrics/BlockLength
                  # GET /api/v1/issue/{issue_name}/event/{event_name}/donations
                  routing.get do
                    find_donations = Services::GetDonation.new.call(event_name: event_name)

                    if find_donations.failure?
                      failed = Representer::HttpResponse.new(find_donations.failure)
                      routing.halt failed.http_status_code, failed.to_json
                    end

                    http_response = Representer::HttpResponse.new(find_donations.value!)
                    response.status = http_response.http_status_code

                    Representer::DonationsList.new(find_donations.value!.message).to_json
                  rescue StandardError => e
                    puts e.message

                    routing.redirect '/'
                  end

                  # POST /api/v1/issue/{issue_name}/event/{event_name}/donations
                  routing.post do
                    add_donation = Services::AddDonationQueue.new.call(event_name: event_name)

                    if add_donation.failure?
                      failed = Representer::HttpResponse.new(add_donation.failure)
                      routing.halt failed.http_status_code, failed.to_json
                    end

                    http_response = Representer::HttpResponse.new(add_donation.value!)
                    response.status = http_response.http_status_code

                    add_donation.value!.message.to_json
                  rescue StandardError => e
                    puts e.message

                    routing.redirect '/'
                  end
                end

                # POST /api/v1/issue/{issue_name}/event/{event_name}
                routing.post do
                  add_event = Services::AddEvent.new.call(issue_name: issue_name, event_name: event_name)

                  if add_event.failure?
                    failed = Representer::HttpResponse.new(add_event.failure)
                    routing.halt failed.http_status_code, failed.to_json
                  end

                  http_response = Representer::HttpResponse.new(add_event.value!)
                  response.status = http_response.http_status_code
                  Representer::Event.new(add_event.value!.message).to_json
                rescue StandardError => e
                  puts e.message

                  routing.redirect '/'
                end
              end
            end

            # POST /api/v1/issue/{issue_name}
            routing.post do
              add_issue = Services::AddIssue.new.call(issue_name: issue_name)

              if add_issue.failure?
                failed = Representer::HttpResponse.new(add_issue.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(add_issue.value!)
              response.status = http_response.http_status_code
              Representer::Issue.new(add_issue.value!.message).to_json
            end
          end
        end

        routing.on 'event' do
          # GET /api/v1/event
          routing.get do
            # response.cache_control public: true, max_age: 300

            find_events = Services::GetEvent.new.call

            if find_events.failure?
              failed = Representer::HttpResponse.new(find_events.failure)
              routing.halt failed.http_status_code, failed.to_json
            end

            http_response = Representer::HttpResponse.new(find_events.value!)
            response.status = http_response.http_status_code

            Representer::EventAllList.new(find_events.value!.message).to_json
          rescue StandardError => e
            puts e.full_message

            routing.redirect '/'
          end
        end

        routing.on 'news' do # rubocop:disable Metrics/BlockLength
          # DELETE /api/v1/news
          routing.delete do
            find_news = Services::DeleteAllNews.new.call

            if find_news.failure?
              failed = Representer::HttpResponse.new(find_news.failure)
              routing.halt failed.http_status_code, failed.to_json
            end

            http_response = Representer::HttpResponse.new(find_news.value!)
            response.status = http_response.http_status_code

            { message: 'All news deleted' }.to_json
          rescue StandardError => e
            puts e.full_message

            routing.redirect '/'
          end

          # GET /api/v1/news/{news_id}
          routing.on String do |news_id|
            routing.get do
              # response.cache_control public: true, max_age: 300

              find_recommendation = Services::GetRecommendation.new.call(news_id: news_id)

              if find_recommendation.failure?
                failed = Representer::HttpResponse.new(find_recommendation.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(find_recommendation.value!)
              response.status = http_response.http_status_code

              Representer::RecommendationList.new(find_recommendation.value!.message).to_json
            rescue StandardError => e
              puts e.full_message

              routing.redirect '/'
            end
          end
        end

        routing.on 'donations' do
          # DELETE /api/v1/donations
          routing.delete do
            find_donations = Services::DeleteAllDonation.new.call

            if find_donations.failure?
              failed = Representer::HttpResponse.new(find_donations.failure)
              routing.halt failed.http_status_code, failed.to_json
            end

            http_response = Representer::HttpResponse.new(find_donations.value!)
            response.status = http_response.http_status_code

            { message: 'All donations deleted' }.to_json
          rescue StandardError => e
            puts e.message

            routing.redirect '/'
          end
        end

        routing.on 'recommendations' do
          # DELETE /api/v1/recommendations
          routing.delete do
            find_recommendations = Services::DeleteAllRecommendations.new.call

            if find_recommendations.failure?
              failed = Representer::HttpResponse.new(find_recommendations.failure)
              routing.halt failed.http_status_code, failed.to_json
            end

            http_response = Representer::HttpResponse.new(find_recommendations.value!)
            response.status = http_response.http_status_code

            { message: 'All recommendations deleted' }.to_json
          rescue StandardError => e
            puts e.message

            routing.redirect '/'
          end
        end

        routing.on 'scheduler' do
          # PUT /api/v1/scheduler
          routing.put do
            run_scheduler = Services::ScheduledWorker.new.call

            if run_scheduler.failure?
              failed = Representer::HttpResponse.new(run_scheduler.failure)
              routing.halt failed.http_status_code, failed.to_json
            end
            http_response = Representer::HttpResponse.new(run_scheduler.value!)
            response.status = http_response.http_status_code

            { message: 'Scheduler Succeeded' }.to_json
          rescue StandardError => e
            puts e.message
            routing.redirect '/'
          end
        end
      end
    end
  end
end
