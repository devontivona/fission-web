require 'net/http'
require 'json'

require "#{Rails.root}/app/helpers/kafka_helper"
include KafkaHelper

namespace :events do


  # body TEXT,
  # status TEXT,
  
  # app_id BIGINT,
  # app_name TEXT,
  # app_access_token TEXT,
  # app_created_at TEXT,

  # client_id BIGINT,
  # client_library TEXT,
  # client_version TEXT,
  # client_manufacturer TEXT,
  # client_os TEXT,
  # client_os_version TEXT,
  # client_model TEXT,
  # client_carrier TEXT,
  # client_token TEXT,
  # client_created_at TEXT,

  # experiment_id BIGINT,
  # experiment_name TEXT,

  # variation_id BIGINT,
  # variation_name TEXT,

  def gen_events(app)

    client = app.clients.sample
    exp = app.experiments.sample
    var = exp.variations.sample

    weights = {"0"=>25, "1"=>50, "2"=>5, "3"=>22}
    samples = [
      [['login',:success], ['logout',:success]],
      [['login',:success], ['browse',:success], ['logout',:success]],
      [['login',:success], ['app_crash',:error]],
      [['login',:success], ['add_to_cart',:success], ['logout',:success]]
    ]
    sampler = WeightedRandomizer.new(weights)
    event_path = samples[sampler.sample.to_i]
    # print "#{event_path}\n"

    events = []
    event_path.each do |item|
      event = {}
      event[:body] = item[0]
      event[:status] = item[1]

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

      event[:experiment_id] = exp.id
      event[:experiment_name] = exp.name

      event[:variation_id] = var.id
      event[:variation_name] = var.name
      events << event
    end

    return events
    
  end

  desc "Generates new events"
  task :generate => :environment do

    app = App.first

    uri = URI.parse('http://localhost:3000/events')

    headers = {'Access-Token'=>'921eee9bfdd1086077346f6e6ba0ade8', 'Client-Token'=>'Simulator'}
    loop do
      http = Net::HTTP.new(uri.host,uri.port)
      req = Net::HTTP::Post.new(uri.request_uri, headers)
      req.body = "events=#{Random.rand}"
      res = http.request(req)
      puts "Response #{res.code} #{res.message}: #{res.body}"
      sleep(1.0)
    end


  end


  desc "Consumes events"
  task :consume => :environment do
    qevents = EventsQueue.new

    qevents.bpop() do |message|
      puts "Received: #{message}"
      # sleep(1.1)
    end
  end

  desc "Produce events"
  task :produce => :environment do
    qevents = EventsQueue.new

    app = App.first


    loop do
      events = gen_events(app)
      qevents.push(events.to_json)
      # qevents.push("#{Random.rand}")
      # puts "Sent Events: #{Time.now.to_i}"
      sleep(1.0)
    end
  end

end