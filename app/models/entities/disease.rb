# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Floofloo
  module Entity
    class Disease < Dry::Struct
      include Dry.Types

      attribute :name,        Strict::String
    end
  end
end
