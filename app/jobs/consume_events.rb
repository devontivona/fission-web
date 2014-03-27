require 'cql'
require 'json'



class ConsumeEvents
  @queue = :consume_events

  def prepare_cql_insert(column_family)
    $cql_db.prepare("insert into #{column_family} (id, animal, fruit, rnumber) values (?,?,?,?)")
  end
  def self.insert_event(args)
    %{INSERT INTO applications.events (bucket, id, app_id, event) VALUES ('#{args[:bucket]}', now(), #{args[:app_id]}, '#{args[:event]}');}
  # "INSERT INTO applications.events (bucket, id, app_id, event) VALUES (?, now(), ?, ?);"
  end


  def self.perform(args)
    
    puts "Consuming Events #{args}"

    # @cassandra = Cql::Client.connect(Rails.application.config.cassandra)
    # @cassandra.execute('INSERT INTO applications.events (bucket, id, app_id, event) VALUES (?, now(), ?, ?)
    #   ', 'sue', 'Sue Smith', type_hints: [nil, :int])
    qevents = EventsQueue.new

    qevents.bpop() do |messages|
      
      puts "Received: #{message}"
      events = JSON.parse(messages)
      puts events[0]['variation_id']

      # args = {}


      # events.each do |event|
      #   args[:event] = event.to_json.gsub("'", "''")
        
      #   @cassandra.execute( insert_event(args) )
      #   # puts "Inserted #{args[:event]}"
      #   puts "Inserted #{insert_event(args)}"
      # end

    end

  rescue SQLite3::BusyException => e
    puts "Performing #{self} caused an exception (#{e}). Retrying..."
    sleep(15)
    Resque.enqueue self, *args
  end


end
