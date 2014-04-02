require 'net/http'
require 'json'

# require "#{Rails.root}/app/helpers/cassandra_helper"
# include CassandraHelper

require "#{Rails.root}/app/helpers/kafka_helper"
include KafkaHelper

namespace :events do

  def gen_events(app, client)

    exp = app.experiments.sample
    var = exp.variations.sample

    weights = {a:15, b:40, c:25, d:5, e:10, f: 5}
    samples = {
      a: [['open',:info], ['login',:info], ['settings',:info], ['close',:info]],
      b: [['open',:info], ['login',:info], ['browse',:info], ['browse',:info], ['browse',:info], ['close',:info]],
      c: [['open',:info], ['login',:info], ['browse',:info], ['close',:info]],
      d: [['open',:info], ['login',:info], ['app_crash',:error]],
      e: [['open',:info], ['login',:info], ['add_to_cart',:info], ['close',:info]],
      f: [['open',:info], ['app_crash',:error]]
    }
    sampler = WeightedRandomizer.new(weights)
    event_path = samples[sampler.sample]

    events = []
    event_path.each do |item|
      event = Event.new
      event.app = app
      event.client = client
      event.name  = item[0]
      event.status = item[1]
      event.second = rand(0..59)
      event.minute = rand(0..59)
      event.hour = rand(0..23)
      event.week = rand(0..355)/7
      event.day = (Time.now.getutc.day - rand(0..5)).abs 
      event.month = Time.now.getutc.month
      event.year = Time.now.getutc.year
      time = Time.mktime( event.year, event.month, event.day==0 ? 1 : event.day , event.hour, event.minute, event.second )
      event.client_timestamp = time.getutc.to_i - rand(10..1000)
      event.server_timestamp = time.getutc.to_i
      # event.bucket = Time.now.getutc.strftime "%Y-%m-%d-%H"
      events << event
    end

    return events
    
  end

  desc "Generates new events"
  task :generate => :environment do

    app = App.first
    uri = URI.parse('http://localhost:3000/events')

    headers = {'Access-Token'=>app.access_token}
    loop do
      client = app.clients.sample
      headers['Client-Token'] = client.token

      events = gen_events(app, client)
      http = Net::HTTP.new(uri.host,uri.port)
      req = Net::HTTP::Post.new(uri.request_uri, headers)
      req.body = "events=#{events.to_json}"
      res = http.request(req)
      puts "Response #{res.code} #{res.message}: #{res.body}"
      sleep(1.0)
    end

  end


  # desc "Check running Applications"
  # task :consume => :environment do
  #   Resque.enqueue(ConsumeEvents, {})
  # end

  desc "Consumes events"
  task :consume => :environment do
  
    event_queue = EventsQueue.new
    event_queue.bpop() do |messages|
      events = JSON.parse(messages, {symbolize_names: true})
      events.each do |json_data|
        Event.create(json_data)
      end
    end

  end

  desc "Produce events"
  task :produce => :environment do
    qevents = EventsQueue.new

    app = App.first
    loop do
      events = gen_events(app)
      qevents.push(events.to_json)
      sleep(1.0)
    end
  end

end