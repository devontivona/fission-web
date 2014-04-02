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
require 'elasticsearch'


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


  # {day: 4, hour: 22, minute: 8, app_id: 1}
  def self.name_per_minute(params={})
    

    query = {}
    query[:aggs] = {}
    query[:aggs][:name_per_minute] = {}
    query[:aggs][:name_per_minute][:filter] = {}
    query[:aggs][:name_per_minute][:filter][:and] = []


    query[:aggs][:name_per_minute][:filter][:and] << { term: {day: params[:day]} }
    query[:aggs][:name_per_minute][:filter][:and] << { term: {hour: params[:hour]} }
    query[:aggs][:name_per_minute][:filter][:and] << { term: {minute: params[:minute]} }


    query[:aggs][:name_per_minute][:aggs] = {}
    query[:aggs][:name_per_minute][:aggs][:path] = {}
    query[:aggs][:name_per_minute][:aggs][:path] = { terms: {field: 'name'}}

    puts query.to_json
    @esc ||= Elasticsearch::Client.new
    @esc.search(index: 'events', type: params[:app_id], body: query)
  end

  # {day: 4, hour: 22, minute: 8, app_id: 1}
  def self.name_per_hour(params={})    

    query = {}
    query[:aggs] = {}
    query[:aggs][:name_per_hour] = {}
    query[:aggs][:name_per_hour][:filter] = {}
    query[:aggs][:name_per_hour][:filter][:and] = []


    query[:aggs][:name_per_hour][:filter][:and] << { term: {day: params[:day]} }
    query[:aggs][:name_per_hour][:filter][:and] << { term: {hour: params[:hour]} }


    query[:aggs][:name_per_hour][:aggs] = {}
    query[:aggs][:name_per_hour][:aggs][:path] = {}
    query[:aggs][:name_per_hour][:aggs][:path] = { terms: {field: 'name'}}

    puts query.to_json
    @esc ||= Elasticsearch::Client.new
    @esc.search(index: 'events', type: params[:app_id], body: query)
  end




  def save()
    prepare() unless @statement and @esc

    payload = to_json()

    if self.app.is_a?(Hash) and self.client.is_a?(Hash)
      
      app_id = self.app[:id]
      client_id = self.client[:id]
    else
      app_id = self.app.id
      client_id = self.client.id
    end

    @statement.execute(app_id, client_id, payload)
    puts @esc.index(index: 'events', type: "#{app_id}-#{client_id}", body: payload)


    
    
  end

  def to_json(*a)
    as_json.to_json(*a, except: ['statement', 'select_statement', 'cql', 'esc'])
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

    @esc ||= Elasticsearch::Client.new
  end



end
