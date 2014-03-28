require 'net/http'
require 'json'
require 'ab_test'

require "#{Rails.root}/app/helpers/cassandra_helper"
include CassandraHelper

namespace :split do


  desc "Check running Applications"
  task :generate => :environment do

    app = App.first
    excf = VariationsColumnFamily.new
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


  desc "Compute Split test on all experiments"
  task :process => :environment do

    experiment = Experiment.find 2

    results = ABTest.score(experiment.variations,experiment.outcome)
    experiment.best = results.best
    experiment.base = results.base
    experiment.worst = results.worst
    experiment.choice = results.choice
    experiment.save
    results.variations.select(&:save)
    
    # puts ABTest.score(experiment.all, experiment.outcome)

    # puts VariationsColumnFamily.counts(Variation.first)

    # app = App.first
    # excf = VariationsColumnFamily.new
    # query = {app_id:app.id}
    # app.experiments.each do |experiment|
    #   experiment.variations.each do |variation|

    #     query[:experiment_id] = experiment.id
    #     query[:variation_id]  = variation.id

    #     excf.select(query).each do |row|
    #       puts row.inspect
    #     end

    #   end
    # end
  
  end

end