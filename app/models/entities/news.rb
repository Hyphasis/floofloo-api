# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Floofloo
  module Entity
    class News < Dry::Struct
      include Dry.Types

      attribute :status,        Strict::String
      attribute :total_results, Strict::Integer
      attribute :author,        Strict::String
      attribute :title,         Strict::String
      attribute :url,           Strict::String
      attribute :urlToImage,    Strict::String
    end
  end
end
