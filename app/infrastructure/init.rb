# frozen_string_literal: true

folders = %w[news donation database]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
