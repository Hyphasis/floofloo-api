# frozen_string_literal: true

require 'vcr'
require 'webmock'

# Setting up VCR
module VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'
  NEWS_CASSETTE = 'news_api'

  def self.setup_vcr
    VCR.configure do |c|
      c.cassette_library_dir = CASSETTES_FOLDER
      c.hook_into :webmock
      c.ignore_localhost = true # for acceptance tests
    end
  end

  def self.configure_vcr_for_news(recording: :new_episodes)
    VCR.configure do |c|
      c.filter_sensitive_data('<NEWS_KEY>') { NEWS_KEY }
      c.filter_sensitive_data('<NEWS_KEY_ESC>') { CGI.escape(NEWS_KEY) }
    end

    VCR.insert_cassette NEWS_CASSETTE,
                        record: recording,
                        match_requests_on: %i[method uri headers],
                        allow_playback_repeats: true
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
