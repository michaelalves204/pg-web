# frozen_string_literal: true

require 'sqlite3'
require_relative '../connection'

class PostgresCredentials
  def initialize
    create_table
  end

  def insert_credential(host, username, password, port)
    credential = find_credential(host, username, password, port)

    return credential[5] unless credential.nil?

    db.execute("INSERT INTO postgres_credentials (host, username, password, port, uid)
                VALUES (?, ?, ?, ?, ?)", [host, username, password, port, uid_generate])

    find_credential(host, username, password, port)[5]
  end

  def find_credential_by_uid(uid)
    db.get_first_row('SELECT * FROM postgres_credentials WHERE uid = ?', uid)
  end

  def find_credential(host, username, password, port)
    db.get_first_row(query_select_credential, [host, username, password, port])
  end

  private

  def uid_generate
    (0...32).map { rand(65..90).chr }.join
  end

  def create_table
    db.execute(create_table_query)
  end

  def query_select_credential
    <<-SQL
      SELECT * FROM postgres_credentials
      WHERE
      host = $1 AND
      username = $2 AND
      password = $3 AND
      port = $4
    SQL
  end

  def create_table_query
    <<-SQL
      CREATE TABLE IF NOT EXISTS postgres_credentials (
        id INTEGER PRIMARY KEY,
        host TEXT,
        username TEXT,
        password TEXT,
        port INTEGER,
        uid TEXT
      );
    SQL
  end

  def db
    @db ||= SQLite3::Database.new 'sqlite3.db'
  end

  def connection(_uid)
    Connection.new(@uid, @database_name).call.checkout
  end
end
