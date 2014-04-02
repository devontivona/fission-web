require 'cql'


$cql =  ConnectionPool::Wrapper.new(size: 10, timeout: 3) { 
  Cql::Client::connect(Rails.application.config.cassandra)
}