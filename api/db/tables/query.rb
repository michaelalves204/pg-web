# frozen_string_literal: true

require_relative '../base'
module Tables
  class Query < Base
    def initialize(database_name, uid)
      @database_name = database_name

      super(database_name, uid)
    end

    def public
      execute_query(query_public)
    end

    def schema(table_name)
      execute_query_params(query_schema, table_name)
    end

    private

    def query_public
      <<~SQL
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public';
      SQL
    end

    def query_schema
      <<~SQL
        SELECT column_name, data_type
        FROM information_schema.columns
        WHERE table_schema = 'public'
            AND table_name = $1;
      SQL
    end
  end
end
