Resque.redis = Redis.new(Rails.application.config.redis)

# Resque.after_fork = proc do
#   $cql =  Cql::Client::connect(Rails.application.config.cassandra)
# end
