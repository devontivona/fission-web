require 'json'

class ConsumeEvents
  @queue = :consume_events

  def self.perform(args)
    puts "Consuming Events #{args}"

    event_queue = EventsQueue.new
    event_queue.bpop() do |messages|
      events = JSON.parse(messages, {symbolize_names: true})
      events.each do |json_data|
        Event.create(json_data)
      end
    end

  end
end
