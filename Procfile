web: bundle exec rails server -p $PORT -e development
consumer: env TERM_CHILD=1 VERBOSE=true QUEUE=consume_events INTERVAL=5 COUNT='2' bundle exec rake resque:work