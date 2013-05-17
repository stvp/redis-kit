# Resque handles its own Redis connection, reconnecting after forks. If $redis
# is a separate connection, however, we'll disconnect it automatically after a
# fork so that the job can use the connection if it wants. If Resque is using
# the $redis connection, we let Resque handle it.

module RedisKit
  module Resque
    # Don't clobber any existing hooks. Resque 1.24 changed the way hooks are
    # stored, so we have to branch for that.
    def self.setup
      existing_hook = ::Resque.after_fork

      if existing_hook == nil || existing_hook.is_a?(Array)
        # resque >= 1.24 (or <= 1.23 with no existing hook)
        ::Resque.after_fork do |job|
          check_redis
        end
      elsif existing_hook.is_a?(Proc)
        # resque <= 1.23
        ::Resque.after_fork do |job|
          existing_hook.call( job )
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

