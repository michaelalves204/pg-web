# frozen_string_literal: true

require 'pg'
require 'connection_pool'
require 'dotenv/load'
require_relative 'sqlite3/postgres_credentials'

class Connection
  def initialize(uid, database_name = nil)
    @database_name = database_name
    @uid = uid
  end

  def call
    @call ||= ConnectionPool.new(size: 15, timeout: 300) do
      PG.connect(
        host: postgres_credential[1],
        dbname: @database_name,
        user: postgres_credential[2],
        password: postgres_credential[3],
        port: postgres_credential[4]
      )
    end
  end

  def postgres_credential
    @postgres_credential ||=
      PostgresCredentials.new.find_credential_by_uid(@uid)
  end
end
