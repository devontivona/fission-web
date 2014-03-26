namespace :events do

  desc "Generates new events"
  task :generate => :environment do

    # [#<Client id: 1, library: "iOS", version: "0.1.0", manufacturer: "Apple", os: "iPhone OS", os_version: "7.1", model: "iPhone Simulator", carrier: nil, token: "Simulator", created_at: "2014-03-26 19:34:17", updated_at: "2014-03-26 19:34:17", app_id: 1>]>

    app = App.first
    puts app.inspect
    puts app.clients.inspect

    
  end


  desc "Consumes events"
  task :consume => :environment do

  end

end