web:    bundle exec puma -E production -b unix:///tmp/teamroq.sock
worker: bundle exec rake resque:work QUEUE=* -E production
thin:  bundle exec rackup private_pub.ru -s thin -E production

