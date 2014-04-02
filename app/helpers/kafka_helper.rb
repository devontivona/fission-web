require 'kafka'

module KafkaHelper

  # To start Kafka with Topic "fission.events"
  # zookeeper-server-start.sh /usr/local/kafka/config/zookeeper.properties
  # kafka-server-start.sh /usr/local/kafka/config/server.properties
  # kafka-server-start.sh /usr/local/kafka/config/server1.properties
  # kafka-topics.sh --zookeeper localhost:2181 --create --topic fission.events --partitions 1 --replication-factor 1

  class DistQueue   
    
    def push(message)        
      # @producer = Poseidon::Producer.new([@options[:url]], 'fission_producer') unless @producer
      # @producer.send_messages([Poseidon::MessageToSend.new(@topic,message)])
      opts = {host: 'localhost', port: 9092, topic: 'fission.events'}
      producer = Kafka::Producer.new(opts)
      producer.push(Kafka::Message.new(message))
    end

    def bpop()
      uri = @options[:url].split(':')
      @consumer = Poseidon::PartitionConsumer.new('fission_consumer', uri[0], uri[1], @topic, 0, :latest_offset)

      loop do
        messages = @consumer.fetch
        messages.each do |message|
          yield message.value
        end
        sleep(0.25)
      end
    end

    def bpop()
      opts = {host: 'localhost', port: 9092, topic: 'fission.events'}
      consumer = Kafka::Consumer.new(opts)
      consumer.loop do |messages|
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
