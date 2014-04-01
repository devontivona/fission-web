# == Schema Information
#
# Table name: clients
#
#  app_id    :long
#  client_id :long
#  id        :timeuuid
#  body      :text
#
require 'json'

class Event

  # Cassandra Variables
  attr_accessor :id, :app_id, :experiment_id


  attr_accessor :app, :client
  attr_accessor :second, :minute, :hour, :day, :week, :month, :year
  attr_accessor :name, :status
  attr_accessor :server_timestamp, :client_timestamp




  def initialize(params={})
    params.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def self.create(params={})
    e = new(params).save
  end

  def keyspace
    'fission_dev'
  end

  def column_family
    'events'
  end




  def save()
    prepare() unless @statement
    if self.app.is_a?(Hash) and self.client.is_a?(Hash)
      puts "Saving as Hash"
      @statement.execute(self.app[:id], self.client[:id], to_json())
    else
      @statement.execute(self.app.id, self.client.id, to_json())
    end
  end
  

  def to_json(*a)
    as_json.to_json(*a, except: ['statement', 'select_statement', 'cql'])
  end

  

  private 

  def prepare()
    @options = Rails.application.config.cassandra
    @cql = Cql::Client::connect(@options)

    @statement = @cql.prepare(
      %{INSERT INTO #{keyspace()}.#{column_family()} ( 
        id,
        app_id,
        client_id,
        body
      ) VALUES (now(),?,?,?)}
    )
  end



end
