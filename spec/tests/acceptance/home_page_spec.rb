# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/home_page'

describe 'Homepage Acceptance Tests' do
  include PageObject::PageFactory

  before do
    DatabaseHelper.wipe_database
    @browser = Watir::Browser.new :chrome, headless: true
  end

  after do
    @browser.close
  end
  describe 'Visit Home page' do
    it '(HAPPY) should not see keywords if none created' do
      # GIVEN: user has not input keywords
      # WHEN: they visit the home page
      visit HomePage do |page|
        # THEN: they should see basic headers, no keywords
        _(page.add_button_element.present?).must_equal true
        _(page.keywords_input_element.present?).must_equal true
      end
    end

    describe 'Add News' do
      it '(HAPPY) should be able to request a news' do
        @browser.goto homepage
        good_news_keywords = KEYWORDS
        @browser.text_field(id: 'keywords').set(good_news_keywords)
        @browser.button(id: 'repo-form-submit').click
        @browser.url.include? KEYWORDS
      end
    end
  end
end
