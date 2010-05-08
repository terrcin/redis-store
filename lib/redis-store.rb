require "redis"
require "redis/distributed"
require "redis/redis_factory"
require "redis/marshaled_redis"
require "redis/distributed_marshaled_redis"

# Cache store
if defined?(Sinatra)
  require "cache/sinatra/redis_store"
elsif defined?(Merb)
  # HACK for cyclic dependency: redis-store is required before merb-cache
  module Merb; module Cache; class AbstractStore; end end end
  require "cache/merb/redis_store"
elsif defined?(Rails) and !defined?(Rails::Railtie)
  require "cache/rails/redis_store"
end

# Rack::Session
if defined?(Rack::Session) and !defined?(Rails::Railtie)
  require "rack/session/abstract/id"
  require "rack/session/redis"
  if defined?(Merb)
    require "rack/session/merb"
  end
end

# Rack::Cache
if defined?(Rack::Cache)
  require "rack/cache/key"
  require "rack/cache/redis_metastore"
  require "rack/cache/redis_entitystore"
end

# Rails3
if defined?(Rails::Railtie)
  require 'railtie'
end
