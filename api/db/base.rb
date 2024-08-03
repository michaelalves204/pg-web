# frozen_string_literal: true

require_relative 'connection'

class Base
  def initialize(database_name, uid)
    @datase_name = database_name
    @uid = uid
  end

  def execute_query(query)
    connection.exec(query).map do |tuple|
      tuple
    end
  end

  def execute_query_params(query, params)
    connection.exec(query, [params]).map do |tuple|
      tuple
    end
  end

  def connection
    @connection ||= Connection.new(@uid, @database_name).call.checkout
  rescue PG::ConnectionBad => e
    { 'error': e.to_s }
  end
end
