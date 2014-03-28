require 'net/http'
require 'json'

require "#{Rails.root}/app/helpers/cassandra_helper"
include CassandraHelper

namespace :split do


  desc "Check running Applications"
  task :test => :environment do

    app = App.first
    excf = ExperimentsColumnFamily.new
    record = {app_id: app.id}
    loop do

      exp = app.experiments.sample
      var = exp.variations.sample

      record[:experiment_id] = exp.id
      record[:variation_id]  = var.id

      if [true, false].sample
        puts "insert_success"
        excf.insert_success(record)
      else
        puts "insert_fail"
        excf.insert_fail(record)
      end
      # sleep(1.0)
    end


  end

end