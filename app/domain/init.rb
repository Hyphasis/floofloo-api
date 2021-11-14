# frozen_string_literal: true

folders = %w[issues articles]
folders.each do |folder|
  require_relative "#{folder}/init"
end
