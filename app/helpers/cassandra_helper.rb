require 'cql'

module CassandraHelper

  class Cassandra
    def prepare() raise NotImplementedError end
  end

  class ExperimentsColumnFamily < Cassandra 

    # app_id BIGINT,
    # experiment_id BIGINT,
    # variation_id BIGINT,

    # success_count COUNTER,
    # total_count COUNTER
    def initialize
      @keyspace = 'fission_dev'
      @column_family = 'variations'    
      prepare()
    end

    def prepare
      @options = Rails.application.config.cassandra
      @client = Cql::Client::connect(@options)

      if @client
      @success_statement = @client.prepare(%{
        UPDATE #{@keyspace}.#{@column_family}
          SET total_count = total_count + 1, success_count = success_count + 1
          WHERE app_id=? AND experiment_id=? AND variation_id=?
      })
      @fail_statement = @client.prepare(%{
        UPDATE #{@keyspace}.#{@column_family}
          SET total_count = total_count + 1
          WHERE app_id=? AND experiment_id=? AND variation_id=?
      })
      else
        raise 'Cassandra client is Nil'
      end
    end

    def insert_success(record)
      if @success_statement
        @success_statement.execute(record[:app_id],record[:experiment_id], record[:variation_id])
      end
    end
    def insert_fail(record)
      if @fail_statement
        @fail_statement.execute(record[:app_id],record[:experiment_id], record[:variation_id])
      end
    end

  end





  class EventsColumnFamily < Cassandra 

    def initialize
      @keyspace = 'fission_dev'
      @column_family = 'events'      
      prepare()
    end

    def prepare
      @options = Rails.application.config.cassandra
      @client = Cql::Client::connect(@options)

      if @client
      @statement = @client.prepare(
        %{INSERT INTO #{@keyspace}.#{@column_family} (
          id, created_at, dbucket, hbucket, mbucket,
          body, status, app_id, app_name,
          app_access_token, app_created_at, client_id,
          client_library, client_version, client_manufacturer,
          client_os, client_os_version, client_model,
          client_carrier, client_token, client_created_at, 
          experiment_id, experiment_name, variation_id, variation_name
        ) VALUES (now(),dateof(now()),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}
      )
      else
        raise 'Cassandra client is Nil'
      end
    end

    def insert(record)
      if @statement and record
        @statement.execute(
          record[:dbucket], record[:hbucket], record[:mbucket],
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
