require "rubygems"
require "bundler/setup"
require "redis"
require "hiredis" if RUBY_ENGINE != "jruby"

module RedisKit
  class MissingConfigError < StandardError ; end

  # Try loading the Redis config from an environment variable or, if there isn't
  # one, a YAML config file.
  def self.load_config( path = "config/redis.yml", env = "development" )
    opts = {}
    opts[:driver] = :hiredis if use_hiredis?

    if url = url_from_env
      opts.merge( url: url )
    else
      config = config_from_yml( path, env )
      opts.merge( config )
    end
  end

  # Try to find a Redis URL in one of the usual ENV variables.
  def self.url_from_env
    %w{ REDIS_URL REDISGREEN_URL OPENREDIS_URL REDISTOGO_URL }.map do |var|
      ENV[var]
    end.find do |url|
      url
    end
  end

  # Load the Redis configuration for the given environment. The YAML file will
  # be passed through ERB before being parsed.
  def self.config_from_yml( path, env )
    require 'erb'
    config = YAML.load ERB.new( IO.read( path ) ).result

    if config.key?( env )
      symbolize_keys( config[env] )
    else
      raise MissingConfigError.new <<-TXT
There is no Redis config for the #{env.inspect} environment in #{path}.
Either add one or set your Redis URL with an ENV variable like "REDIS_URL".
      TXT
    end
  rescue Psych::SyntaxError => e
    raise <<-TXT
A YAML syntax error occurred while parsing #{path}. Please note that YAML
must be consistently indented using spaces. Tabs are not allowed.
Error: #{e.message}"
TXT
  end

  private

  def self.use_hiredis?
    RUBY_ENGINE != "jruby"
  end

  def self.symbolize_keys( hash )
    hash.each_with_object({}) do |(k,v), h|
      h[k.to_sym] = v
    end
  end
end

require "redis-kit/version"
require "redis-kit/railtie" if defined?( Rails )
require "redis-kit/resque" if defined?( Resque )

