require 'net/http'
require 'json'

require "#{Rails.root}/app/helpers/kafka_helper"
require "#{Rails.root}/app/helpers/cassandra_helper"
include CassandraHelper
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
      event = {}
      event[:body] = item[0]
      event[:status] = item[1]
      event[:client_timestamp] = Time.now.to_i
      event[:second] = Time.now.to_i
      event[:minute_bucket] = Time.now.getutc.min
      event[:hour_bucket] = Time.now.getutc.hour
      event[:week_bucket] = Time.now.getutc.yday/7
      event[:day_bucket] = Time.now.getutc.day
      event[:month_bucket] = Time.now.getutc.month
      event[:year_bucket] = Time.now.getutc.year

      event[:app_id] = app.id
      event[:app_name] = app.name
      event[:app_access_token] = app.access_token
      event[:app_created_at] = app.created_at

      event[:client_id] = client.id
      event[:client_library] = client.library
      event[:client_version] = client.version
      event[:client_manufacturer] = client.manufacturer
      event[:client_os] = client.os
      event[:client_os_version] = client.os_version
      event[:client_model] = client.model
      event[:client_carrier] = client.carrier
      event[:client_token] = client.token
      event[:client_created_at] = client.created_at
      events << event
    end

    return events
    
  end

  desc "Generates new events"
  task :generate => :environment do

    app = App.first
    uri = URI.parse('http://localhost:3000/events')

    headers = {'Access-Token'=>'921eee9bfdd1086077346f6e6ba0ade8'}
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


  desc "Check running Applications"
  task :consume => :environment do
    Resque.enqueue(ConsumeEvents, {})
  end

  # desc "Consumes events"
  # task :consume => :environment do
  #   # qevents = EventsQueue.new

  #   # qevents.bpop() do |message|
  #   #   puts "Received: #{message}"
  #   #   # sleep(1.1)
  #   # end

  #   qevents = EventsQueue.new
  #   cql = EventsColumnFamily.new

  #   qevents.bpop() do |messages|
  #     events = JSON.parse(messages, {symbolize_names: true})
  #     events.each do |event|
  #       cql.insert(event)
  #     end
  #     sleep(1.1)
  #   end
  # end

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