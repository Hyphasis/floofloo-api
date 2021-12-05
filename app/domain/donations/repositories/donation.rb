# frozen_string_literal: true

module Floofloo
  module Repository
    # Repository for Donation Entities
    class Donation
      def self.all
        Database::DonationOrm.all.map { |db_donation| rebuild_entity(db_donation) }
      end

      def self.find(entity)
        find_origin_id(entity.origin_id)
      end

      def self.find_id(id)
        db_news = Database::DonationOrm.first(id: id)
        rebuild_entity(db_news)
      end

      def self.find_event_id(event_id)
        Database::DonationOrm.where(event_id: event_id).all
      end

      def self.find_title(title)
        db_donation = Database::DonationOrm.first(title: title)
        rebuild_entity(db_donation)
      end

      def self.create(event, entity)
        event.add_donation(rebuild_entity(entity))
      end

      def self.rebuild_entity(db_donation)
        return nil unless db_donation

        Database::DonationOrm.new(
          title: db_donation.title,
          summary: db_donation.summary,
          country: db_donation.country,
          city: db_donation.city,
          image_url: db_donation.image_url
        )
      end
    end
  end
end
