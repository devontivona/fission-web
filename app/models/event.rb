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
    connect() unless @statement
   

    payload = to_json()
    puts payload
    # # puts "Inserting [#{payload}, #{self.app.id}, #{self.client.id}, #{self.bucket}]"
    # # puts "#{payload} #{payload.class}"
    # # puts "#{}"
    
    # @statement.execute(self.app.id, self.client.id, self.bucket, to_json())
  end

  def get(params=nil)
    connect() unless @select_statement
    result = @select_statement.execute(param[:app_id], params[:client_id], params[:bucket])
    result ? result : []
  end

  

  def to_json(*a)
    as_json.to_json(*a, except: ['statement'])
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
        WHERE app_id=? AND client_id=? AND bucket=?}
    )
  end



end
