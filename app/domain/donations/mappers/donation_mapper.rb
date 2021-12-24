# frozen_string_literal: true

module Floofloo
  module Donation
    # Donation Mapper: GlobalGiving API Donation -> Donation entity
    class DonationMapper
      def initialize(donation_key, gateway_class = Floofloo::Donation::Api)
        @donation_key = donation_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@donation_key)
      end

      # This method smells of :reek:LongParameterList
      def find(keywords)
        data = @gateway.project(keywords)
        projects = data['search']['response']['projects']['project']

        donations = []
        projects.each do |project|
          donations << build_entity(project)
        end

        donations
      end

      # This method smells of :reek:UtilityFunction
      def build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from the data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Floofloo::Entity::Donation.new(
            id: nil,
            title: title,
            summary: summary,
            country: country,
            city: city,
            image_url: image_url,
            project_url: project_url
          )
        end

        private

        def title
          @data['title']
        end

        def summary
          @data['summary']
        end

        def country
          @data['country']
        end

        def city
          @data['contactCity']
        end

        def image_url
          @data['image']['imagelink'].last['url']
        end

        def project_url
          @data['projectLink']
        end
      end
    end
  end
end
