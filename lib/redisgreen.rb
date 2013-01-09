require "rubygems"
require "bundler/setup"

require "redisgreen/version"

module RedisGreen
end

require "redisgreen/railtie" if defined?(Rails)

