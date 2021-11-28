# frozen_string_literal: true

require 'roda'
require 'yaml'
require 'sequel'
require 'figaro'
require 'delegate'

module Floofloo
  # Configuration for the App
  class App < Roda
    plugin :environments

    configure do
      Figaro.application = Figaro::Application.new(
        environment: environment,
        path: File.expand_path('config/secrets.yml')
      )
      Figaro.load

      def self.config() = Figaro.env

      use Rack::Session::Cookie, secret: config.SESSION_SECRET

      configure :development, :test, :app_test do
        ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
      end

      configure :app_test do
        require_relative '../spec/helpers/vcr_helper'
        VcrHelper.setup_vcr
        VcrHelper.configure_vct_for_news(recording: :none)
      end

      # Database Setup
      DB = Sequel.connect(ENV['DATABASE_URL']) # rubocop:disable Lint/ConstantDefinitionInBlock
      def self.DB() = DB # rubocop:disable Naming/MethodName
    end
  end
end
