require "rubygems"
require "bundler/setup"
require "yaml"
require "redis"
require "hiredis" if RUBY_ENGINE != "jruby"

module RedisKit
  class MissingConfigError < StandardError ; end
  class InvalidConfigSyntaxError < StandardError ; end

  CUSTOM_CONFIG_KEYS = [:mock]

  class << self
    attr_writer :redis

    def redis
      @redis || $redis
    end
  end

  def self.new_redis( path, env )
    config = load_config( path, env )
    if config[:mock]
      require 'mock_redis'
      MockRedis.new
    else
      Redis.new( config.reject{ |k, v| CUSTOM_CONFIG_KEYS.include?( k ) } )
    end
  end

  # Try loading the Redis config from an environment variable or, if there isn't
  # one, a YAML config file.
  def self.load_config( path, env )
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

    if config == false
      raise MissingConfigError.new "The Redis configuration file at " \
        "#{path} is empty. See the RedisKit README for information about how " \
        "to format this file: https://github.com/stvp/redis-kit"
    elsif config.key?( env )
      symbolize_keys( config[env] )
    else
      raise MissingConfigError.new "There is no Redis config for the " \
        "#{env.inspect} environment in #{path}. Either add one or set your "\
        "Redis URL with an ENV variable like \"REDIS_URL\"."
    end
  rescue Errno::ENOENT
    raise MissingConfigError.new "#{path} doesn't exist. Please add a Redis " \
      "config YAML file or supply an ENV variable like \"REDIS_URL\"."
  rescue Exception => e
    if Object.const_defined?('Psych') && e.class == Psych::SyntaxError
      raise InvalidConfigSyntaxError.new "A YAML syntax error occurred while " \
        "parsing #{path}. Please note that YAML must be consistently indented " \
        "using spaces. Tabs are not allowed.\nError: #{e.message}"
    else
      raise
    end
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

