module Octopus
  class PostgresSchemaScopeProxy < ScopeProxy
    attr_accessor :current_schema

    def initialize(schema, shard, klass)
      @current_schema = schema
      @current_shard = shard
      @klass = klass
    end

    def using_schema(schema)
      @current_schema = schema
      shard = Octopus.config['schemas'][schema]
      fail "Nonexistent Shard Name: #{shard}" if @klass.connection.instance_variable_get(:@shards)[shard].nil?
      @current_shard = shard
      self
    end

    # Transaction Method send all queries to a specified shard.
    def transaction(options = {}, &block)
      run_on_schema { @klass = klass.transaction(options, &block) }
    end

    def method_missing(method, *args, &block)
      result = run_on_schema { @klass.send(method, *args, &block) }
      if result.respond_to?(:all)
        @klass = result
        return self
      end

      result
    end
  end
end
