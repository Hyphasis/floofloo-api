# frozen_string_literal: true

folders = %w[issues articles donations]
folders.each do |folder|
  require_relative "#{folder}/init"
end
