require 'cql'

module CassandraHelper

  class Cassandra
    def prepare() raise NotImplementedError end
  end

  class EventsColumnFamily < Cassandra 

    def initialize
      @keyspace = 'fission_dev'
      @column_family = 'events'
      @options = Rails.application.config.cassandra
      @client = Cql::Client::connect(@options)
      
      prepare()
    end

    def prepare
      if @client
      # @statement = $cql_db.prepare("insert into #{column_family} (id, animal, fruit, rnumber) values (?,?,?,?)")
      @statement = @client.prepare(
        %{INSERT INTO #{@keyspace}.#{@column_family} (
          id, created_at, body, status, app_id, app_name,
          app_access_token, app_created_at, client_id,
          client_library, client_version, client_manufacturer,
          client_os, client_os_version, client_model,
          client_carrier, client_token, client_created_at, 
          experiment_id, experiment_name, variation_id, variation_name
        ) VALUES (now(),dateof(now()),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}
      )
      else
        raise 'Cassandra client is Nil'
      end
    end

    def insert(record)
      if @statement and record
        @statement.execute(
          record[:body], record[:status], record[:app_id], record[:app_name],
          record[:app_access_token], record[:app_created_at], record[:client_id],
          record[:client_library], record[:client_version], record[:client_manufacturer],
          record[:client_os], record[:client_os_version], record[:client_model],
          record[:client_carrier], record[:client_token], record[:client_created_at],
          record[:experiment_id], record[:experiment_name], 
          record[:variation_id], record[:variation_name]
        )
      end
    end



  end

end
