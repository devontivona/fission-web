require 'net/http'

require "#{Rails.root}/app/helpers/kafka_helper"
include KafkaHelper

namespace :events do

  desc "Generates new events"
  task :generate => :environment do

    # [#<Client id: 1, library: "iOS", version: "0.1.0", manufacturer: "Apple", os: "iPhone OS", os_version: "7.1", model: "iPhone Simulator", carrier: nil, token: "Simulator", created_at: "2014-03-26 19:34:17", updated_at: "2014-03-26 19:34:17", app_id: 1>]>

    app = App.first
    puts app.inspect
    puts app.clients.inspect


    uri = URI.parse('http://localhost:3000/events')

    headers = {'Access-Token'=>'921eee9bfdd1086077346f6e6ba0ade8', 'Client-Token'=>'Simulator'}
    loop do
      http = Net::HTTP.new(uri.host,uri.port)
      req = Net::HTTP::Post.new(uri.request_uri, headers)
      # req.body = "[ #{data} ]"
      req.body = "events=#{Random.rand}"
      res = http.request(req)
      puts "Response #{res.code} #{res.message}: #{res.body}"
      sleep(1.0)
    end


  end


  desc "Consumes events"
  task :consume => :environment do
    qevents = EventsQueue.new

    qevents.consume() do |message|
      puts "Received: #{message}"
      sleep(1.1)
    end
  end

  desc "Produce events"
  task :produce => :environment do
    qevents = EventsQueue.new

    loop do
      qevents.push("#{Random.rand}")
      sleep(1.0)
    end
    


  end

end