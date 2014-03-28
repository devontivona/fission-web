require 'net/http'
require 'json'
require 'ab_test'

require "#{Rails.root}/app/helpers/cassandra_helper"
include CassandraHelper

namespace :split do


  desc "Check running Applications"
  task :generate => :environment do

    cql = VariationsColumnFamily.new

    app = App.first
    exp = app.experiments.first
    winner_var = exp.variations.first

    record = {app_id: app.id, experiment_id: exp.id}
    loop do

      var = exp.variations.sample

      samples = [false, false, true]
      samples = [false, true, true] if var.id == winner_var.id

      record[:variation_id]  = var.id

      if samples.sample
        puts "insert_success for #{var.id}"
        cql.insert_success(record)
      else
        puts "insert_fail for #{var.id}"
        cql.insert_fail(record)
      end
      # sleep(1.0)
    end
  end


  desc "Compute Split test on all experiments"
  task :process => :environment do

    experiment = Experiment.find 1

    results = ABTest.score(experiment.variations,experiment.outcome)
    experiment.best = results.best
    experiment.base = results.base
    experiment.worst = results.worst
    experiment.choice = results.choice
    experiment.save
    results.variations.select(&:save)
  
  end

end