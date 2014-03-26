require 'singleton'
require 'json'

module KafkaHelper

  class DistQueue   
    
    def push(message)     
      @producer = Kafka::Producer.new(@options) unless @producer
      @producer.push(Kafka::Message.new(message))
    end

    def pop()
      @consumer = Kafka::consumer.new(@options) unless @consumer

      @consumer.loop do |messages|
        messages.each do |message|
          yield message.payload
        end
      end
    end

  end


  class EventsQueue < DistQueue

    def initialize
      @topic = 'fission_events'
      @options = Rails.application.config.kafka
      @options[:topic] = @topic
    end    

  end
end
