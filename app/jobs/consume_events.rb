require 'json'

class ConsumeEvents
  @queue = :consume_events

  def self.perform(args)
    puts "Consuming Events #{args}"

    qevents = EventsQueue.new
    cql = EventsColumnFamily.new

    qevents.bpop() do |messages|
      events = JSON.parse(messages, {symbolize_names: true})
      events.each do |event|
        cql.insert(event)
      end
    end

  end
end
