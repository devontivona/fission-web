# require 'singleton'

module KafkaHelper

  # zookeeper-server-start.sh /usr/local/kafka/config/zookeeper.properties
  # kafka-server-start.sh /usr/local/kafka/config/server.properties
  # kafka-topics.sh --zookeeper localhost:2181 --create --topic fission.events --partitions 1 --replication-factor 1

  class DistQueue   
    
    def push(message)  
      @producer = Poseidon::Producer.new([@options[:url]], @topic)
      @producer.send_messages([Poseidon::MessageToSend.new(@topic,message)])

      # @producer = Kafka::Producer.new(@options) unless @producer
      # @producer.push(Kafka::Message.new(message))
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
      @topic = 'fission.events'
      @options = Rails.application.config.kafka
      @options[:topic] = @topic
    end    

  end
end
