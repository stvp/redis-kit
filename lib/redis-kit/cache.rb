module RedisKit
  class Cache
    class << self
      def get( key, timeout, &block )
        key = key.to_s
        if value = RedisKit.redis.get( key )
          value
        else
          value = yield
          RedisKit.redis.setex key, timeout, value
          value
        end
      end

      def expire( key )
        RedisKit.del key
      end
    end
  end
end

require 'redis-kit/cache/helper'

