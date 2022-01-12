# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'Donation Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_donation(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store donation' do
    before do
      DatabaseHelper.wipe_database
      Floofloo::Services::AddIssue.new.call(issue_name: ISSUE_NAME)
      Floofloo::Services::AddEvent.new.call(issue_name: ISSUE_NAME, event_name: EVENT_NAME)
    end

    it 'HAPPY: should be able to find and save donation to database' do
      donation_made = Floofloo::Services::AddDonationWorker.new.call(event_name: EVENT_NAME)
      _(donation_made.success?).must_equal true

      first_donation = Floofloo::Database::DonationOrm.first

      rebuilt_first_donation = donation_made.value!.message[:donation_list][0]
      _(rebuilt_first_donation.title).must_equal(first_donation.title)
      _(rebuilt_first_donation.summary).must_equal(first_donation.summary)
      _(rebuilt_first_donation.country).must_equal(first_donation.country)
      _(rebuilt_first_donation.city).must_equal(first_donation.city)
      _(rebuilt_first_donation.image_url).must_equal(first_donation.image_url)
      _(rebuilt_first_donation.project_url).must_equal(first_donation.project_url)
    end

    it 'SAD: should fail if no keywords are given.' do
      donation_made = Floofloo::Services::AddDonationWorker.new.call()
      _(donation_made.success?).must_equal false
    end
  end
  describe 'Get Donation from Database' do
    before do
      DatabaseHelper.wipe_database
      Floofloo::Services::AddIssue.new.call(issue_name: ISSUE_NAME)
      Floofloo::Services::AddEvent.new.call(issue_name: ISSUE_NAME, event_name: EVENT_NAME)
      @donation_made = Floofloo::Services::AddDonationWorker.new.call(event_name: EVENT_NAME)
      @rebuilt_first_donation = @donation_made.value!.message[:donation_list][0]
    end

    it 'HAPPY: should be able to find and save news to database' do
      donation_found = Floofloo::Services::GetDonation.new.call(event_name: EVENT_NAME)
      _(donation_found.success?).must_equal true

      found_first_news = donation_found.value!.message.donations[0]
      _(found_first_news.title).must_equal(@rebuilt_first_donation.title)
      _(found_first_news.summary).must_equal(@rebuilt_first_donation.summary)
      _(found_first_news.country).must_equal(@rebuilt_first_donation.country)
      _(found_first_news.city).must_equal(@rebuilt_first_donation.city)
      _(found_first_news.image_url).must_equal(@rebuilt_first_donation.image_url)
      _(found_first_news.project_url).must_equal(@rebuilt_first_donation.project_url)
    end
  end

  describe 'Delete Donation from Database' do
    before do
      DatabaseHelper.wipe_database
      Floofloo::Services::AddIssue.new.call(issue_name: ISSUE_NAME)
      Floofloo::Services::AddEvent.new.call(issue_name: ISSUE_NAME, event_name: EVENT_NAME)
      @donation_made = Floofloo::Services::AddDonationWorker.new.call(event_name: EVENT_NAME)
    end

    it 'HAPPY: should be delete donation projects in database' do
      donation_deleted = Floofloo::Services::DeleteAllDonation.new.call()
      _(donation_deleted.success?).must_equal true

      donation_in_database = Floofloo::Database::DonationOrm.all
      _(donation_in_database).must_equal []
    end
  end
end
