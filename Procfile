web: bundle exec puma -C config/puma.rb -b tcp://0.0.0.0:$PORT
release: bundle exec rails db:migrate && bundle exec rails db:seed
