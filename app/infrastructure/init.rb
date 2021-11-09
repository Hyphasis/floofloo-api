# frozen_string_literal: true

folders = %w[news database]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
