# frozen_string_literal: true

# Page object for home page
class HomePage
  include PageObject

  page_url Floofloo::App.config.APP_HOST

  div(:success_message, id: 'flash_bar_success')
  div(:warning_message, id: 'flash_bar_danger')

  text_field(:keywords_input, id: 'keywords')
  button(:add_button, id: 'repo-form-submit')

  def add_new_news(keywords)
    self.keywords_input = keywords
    add_button
  end
end
