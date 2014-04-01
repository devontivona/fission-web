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
require 'json'

class Event

  # Cassandra Variables
  attr_accessor :id, :app_id, :experiment_id, :bucket


  attr_accessor :app, :client
  attr_accessor :second, :minute, :hour, :day, :week, :month, :year
  attr_accessor :name, :status
  attr_accessor :server_timestamp, :client_timestamp




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









  def save()
    


    unless @statement
      connect() 
    end
    # @statement = $cql.prepare(
    #   %{INSERT INTO fission_dev.events ( 
    #     id,
    #     body,
    #     app_id,
    #     client_id,
    #     bucket
    #   ) VALUES (now(),?,?,?,?)}
    # )

    payload = to_json()
    puts payload
    # puts "Inserting [#{payload}, #{self.app.id}, #{self.client.id}, #{self.bucket}]"
    # puts "#{payload} #{payload.class}"


    # puts "#{}"
    
    # @statement.execute(payload, self.app.id, self.client.id, self.bucket)
  end

  def get(params=nil)
    connect() unless @select_statement
    result = @select_statement.execute(param[:app_id], params[:client_id], params[:bucket])
    result ? result : []
  end

  

  def to_json(*a)
    # a.each do |k,v|
    #   puts "#{k}"
    # end
    # puts a.inspect
    as_json.to_json(*a, except: ['statement', 'select_statement'])
  end

  # def as_json(options={})
  #   {
  #     "app" => self.app.as_json,
  #     "client" => self.client.as_json,
  #     "name" => self.name,
  #     "status" => self.status
  #   }
  # end

  

  private 

  

  def connect()
    puts "Connecting"
    @statement = $cql.prepare(
      %{INSERT INTO #{keyspace()}.#{column_family()} ( 
        id,
        app_id,
        client_id,
        bucket,
        body
      ) VALUES (now(),?,?,?,?)}
    )

    @select_statement = $cql.prepare(
      %{SELECT * FROM #{keyspace()}.#{column_family()}
        WHERE app_id=? AND client_id=? AND bucket=?
      }
    )
    puts "Connected"
  end



end
