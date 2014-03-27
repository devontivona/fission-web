module Jobs
  require 'cql'
  require 'json'
  
  class ConsumeEvents
    @queue = :consume_events

    def self.insert_event(args)
      %{INSERT INTO applications.events (bucket, id, app_id, event) VALUES ('#{args[:bucket]}', now(), #{args[:app_id]}, '#{args[:event]}');}
    # "INSERT INTO applications.events (bucket, id, app_id, event) VALUES (?, now(), ?, ?);"
    end


    def self.perform(args)
      
      puts "Consuming Events #{args}"

      channel = args['channel']
      @redis   = Redis.new(Rq::Application.config.redis)
      @cassandra = Cql::Client.connect(Rq::Application.config.cassandra)
      # @cassandra.execute('INSERT INTO applications.events (bucket, id, app_id, event) VALUES (?, now(), ?, ?)
      #   ', 'sue', 'Sue Smith', type_hints: [nil, :int])
      loop do

        list, messages = @redis.blpop(channel)
        json = JSON.parse(messages)
        events = json['events']

        args = {}
        args[:app_id] = json['app']['id']
        args[:bucket] = Time.now.getutc.strftime "%Y-%m-%d-%H"

        # args.select {|k,v| puts v.class}

        events.each do |event|
          args[:event] = event.to_json.gsub("'", "''")
          
          @cassandra.execute( insert_event(args) )
          # puts "Inserted #{args[:event]}"
          puts "Inserted #{insert_event(args)}"
        end

      end

    rescue SQLite3::BusyException => e
      puts "Performing #{self} caused an exception (#{e}). Retrying..."
      sleep(15)
      Resque.enqueue self, *args
    end


  end

end
