# == Schema Information
#
# Table name: clients
#
#  app_id    :long
#  client_id :long
#  bucket    :text
#  id        :timeuuid
#  body      :text
#
require 'cql'

class Event

  attr_accessor :id, :app_id, :experiment_id, :bucket


  def initialize(params={})
    params.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def keyspace
    'fission_dev'
  end

  def column_family
    'events'
  end







  # Save if the user successfully saw a variation
  def save()
    connect() unless @statement
    @statement.execute(self.body, self.app_id, self.client_id, self.bucket)
  end

  def get(params=nil)
    connect() unless @select_statement
    result = @select_statement.execute(param[:app_id], params[:client_id], params[:bucket])
    result ? result : []
  end

  




  

  private 

  def connect()
    @options = Rails.application.config.cassandra
    @client = Cql::Client::connect(@options)

    @statement = @client.prepare(
      %{INSERT INTO #{keyspace()}.#{column_family()} ( 
        id,
        body,
        app_id,
        client_id,
        bucket
      ) VALUES (now(),?,?,?,?)})
    
    @select_statement = @client.prepare(
      %{SELECT * FROM #{keyspace()}.#{column_family()}
        WHERE app_id=? AND client_id=? AND bucket=?
      }
    )
  end



end
