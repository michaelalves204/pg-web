# frozen_string_literal: true

require_relative 'base'

class Query < Base
  def initialize(database_name:, query:, uid:)
    @database_name = database_name
    @query = query
    super(database_name, uid)
  end

  def call
    execute_query(@query)
  end
end
