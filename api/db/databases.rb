# frozen_string_literal: true

require_relative 'base'

class Databases < Base
  def initialize(uid)
    super(nil, uid)
  end

  def call
    execute_query(query)
  end

  private

  def query
    <<~SQL
      SELECT datname FROM pg_database;
    SQL
  end
end
