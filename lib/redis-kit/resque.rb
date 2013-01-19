# Resque handles its own Redis connection, reconnecting after forks. If $redis
# is a separate connection, however, we'll disconnect it automatically after a
# fork so that the job can use the connection if it wants. If Resque is using
# the $redis connection, we let Resque handle it.

module RedisKit
  module Resque
    def self.setup
      # Don't clobber any existing hooks.
      if existing_hook = ::Resque.after_fork
        ::Resque.after_fork do |job|
          existing_hook.call( job )
          check_redis
        end
      else
        ::Resque.after_fork do |job|
          check_redis
        end
      end
    end

    def self.check_redis
      if $redis != ::Resque.redis.redis
        $redis.client.disconnect
      end
    end
  end
end

RedisKit::Resque.setup

