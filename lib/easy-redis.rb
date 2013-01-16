require "rubygems"
require "bundler/setup"

require "easy-redis/version"

module EasyRedis
end

require "easy-redis/railtie" if defined?(Rails)

