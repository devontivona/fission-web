require 'singleton'
require 'json'

module KafkaHelper

  class DistQueue   
    
    def push(message)
      @options[:topic] = @topic
      
      @producer = Kafka::Producer.new(@options) unless @producer
      @producer.push(Kafka::Message.new(message))
    end

    def pop()
      @consumer = Kafka::consumer.new(@options) unless @consumer

    end

  end


  class EventsQueue < DistQueue

    def initialize
      @topic = 'fission_events'
      @options = Rails.application.config.kafka
    end    

  end
end
