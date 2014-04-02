require 'kafka'

$kafka_producers = ConnectionPool::Wrapper.new(size: 10, timeout: 3) { 
  Kafka::Producer.new(Rails.application.config.kafka)
}