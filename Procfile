release: rake db:migrate; rake queues:create
web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: bundle exec shoryuken -r ./workers/add_news_worker.rb -C ./workers/shoryuken_news_production.yml
donation_worker: bundle exec shoryuken -r ./workers/add_donation_worker.rb -C ./workers/shoryuken_donation_production.yml
