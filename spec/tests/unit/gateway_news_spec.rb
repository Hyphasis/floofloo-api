# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'

describe 'Test News API Library' do
  before do
    VcrHelper.configure_vcr_for_news
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'News Information' do
    it 'HAPPY: should provide correct news information' do
      news = Floofloo::News::NewsMapper.new(NEWS_KEY)
        .find(KEYWORDS, FROM, TO, SORT_BY, LANGUAGE)

      _(news.status).must_equal CORRECT['status']
      _(news.total_results).must_equal CORRECT['totalResults']
      _(news.articles[0].author).must_equal CORRECT['author']
      _(news.articles[0].title).must_equal CORRECT['title']
    end

    it 'BAD: sould raise exception when unauthorized' do
      _(proc do
        Floofloo::News::NewsMapper.new('BAD_KEY').find(KEYWORDS, FROM, TO, SORT_BY, LANGUAGE)
      end).must_raise Floofloo::News::Api::Response::Unauthorized
    end
  end
end
