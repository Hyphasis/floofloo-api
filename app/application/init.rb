# frozen_string_literal: true

folders = %w[services controllers requests]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
