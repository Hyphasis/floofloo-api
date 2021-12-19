# frozen_string_literal: true

folders = %w[news donation database cache messaging]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
