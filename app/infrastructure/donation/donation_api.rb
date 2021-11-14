# frozen_string_literal: true

require 'http'
require 'json'
require 'crack'

module Floofloo
  module Donation
    # Library for Global Giving API
    class Api
      # 'https://api.globalgiving.org/api/public/services/search/projects?api_key=YOUR_API_KEY&q=pakistan+flood&filter=theme:disaster'
      DONATION_PATH = 'https://api.globalgiving.org/api/public/services/search/projects'
      def initialize(donation_key)
        @donation_key = donation_key
      end

      # This method smells of :reek:LongParameterList
      def project(keywords)
        project_response = Request.new(DONATION_PATH, @donation_key)
          .project(keywords)

        xml_response = Crack::XML.parse(project_response.body)
        json_response = xml_response.to_json
        JSON.parse(json_response)
      end

      # Send out HTTP request to News API
      class Request
        def initialize(resource_root, key)
          @resource_root = resource_root
          @key = key
        end

        # This method smells of :reek:LongParameterList
        def project(keywords)
          donation_url = "#{@resource_root}?"\
                         "api_key=#{@key}"\
                         "&q=#{keywords}"

          get(donation_url)
        end

        # This method smells of :reek:FeatureEnvy
        def get(url)
          http_response = HTTP.headers(
            'Accept' => 'application/xml',
            'Content-Type' => 'application/xml'
          ).get(url)

          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end
      end

      # Decorate HTTP responses from News API with success/error reporting
      class Response < SimpleDelegator
        # NotFound Error
        NotFound = Class.new(StandardError)

        # Unauthorized Error
        Unauthorized = Class.new(StandardError)

        HTTP_ERROR = {
          401 => Unauthorized,
          404 => NotFound
        }.freeze

        def successful?
          !HTTP_ERROR.keys.include?(code)
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
