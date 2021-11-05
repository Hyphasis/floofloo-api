# frozen_string_literal: true

Dir.glob("#{_dir_}/*.rb").each do |file|
  require file
end
