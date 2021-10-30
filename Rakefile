# frozen_string_literal: true

require 'rake/testtask'

task :default do
  puts `rake -T`
end

desc 'Run tests'
task :spec do
  sh 'Ruby spec/gateway_news_spec.rb'
end

desc 'Run tests'
task :spec do
  sh 'ruby spec/gateway_news_spec.rb'
end

desc 'Keep rerunning tests upon changes'
task :respec do
  sh "rerun -c 'rake spec' --ignore 'coverage/*'"
end

task :rerack do
  sh "rerun -c rackup --ignore 'coverage/*'"
end

namespace :vcr do
  desc 'Delete cassette fixtures'
  task :wipe do
    sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
      puts(ok ? 'Cassettes deleted' : 'No cassettes found')
    end
  end
end

namespace :quality do
  only_app = 'config/ app/'

  desc 'Run all static-analysis quality checks'
  task all: %i[rubocop reek flog]

  desc 'Code style linter'
  task :rubocop do
    sh 'rubocop'
  end

  desc 'Code smell detector'
  task :reek do
    sh 'reek'
  end

  desc 'Complexity analysis'
  task :flog do
    sh "flog -m #{only_app}"
  end
end
