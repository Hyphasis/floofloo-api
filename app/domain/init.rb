# frozen_string_literal: true

folders = %w[disasters articles]
folders.each do |folder|
  require_relative "#{folder}/init"
end
