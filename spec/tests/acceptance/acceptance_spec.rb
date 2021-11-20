# frozen_string_literal: true

 require_relative '../../helpers/spec_helper'
 require_relative '../../helpers/database_helper'
 require_relative '../../helpers/vcr_helper'

 require 'headless'
 require 'webdrivers/chromedriver'
 require 'watir'

 describe 'Acceptance Tests' do
   before do
     DatabaseHelper.wipe_database
#      @headless = Headless.new
      @browser = Watir::Browser.new
   end

   after do
     @browser.close
#     @headless.destroy
   end

   describe 'Homepage' do
     describe 'Visit Home page' do
       it '(HAPPY) should go to homepage' do
         @browser.goto homepage
#         _(@browser.h1(id: 'main_header').text).must_equal 'Floofloo'
         _(@browser.text_field(id: 'keywords').present?).must_equal true
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
