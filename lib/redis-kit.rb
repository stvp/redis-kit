require "rubygems"
require "bundler/setup"

require "redis-kit/version"

module RedisKit
end

require "redis-kit/railtie" if defined?(Rails)

