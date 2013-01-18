require "redis"
require "hiredis" if RUBY_ENGINE != "java"

module RedisKit
  class Railtie < Rails::Railtie
    initializer "redis-kit.setup_redis" do |app|
      # Register the path with Rails so that users can change it, if they want.
      unless app.paths["config/redis"]
        app.paths.add "config/redis", with: "config/redis.yml"
      end

      $redis = Redis.new( redis_configuration( app ) )
    end

    private

    # Try to load the Redis config from an environment variable or
    # config/redis.yml
    def redis_configuration( app )
      opts = {}
      opts[:driver] = :hiredis if RUBY_ENGINE != "java"

      if url = find_env_variable
        opts.merge!( url: url )
      else
        opts.merge!( load_config_yml( app ) )
      end

      opts
    end

    def find_env_variable
      %w{REDIS_URL REDISGREEN_URL OPENREDIS_URL REDISTOGO_URL}.map do |var|
        ENV[var]
      end.find do |url|
        url
      end
    end

    def load_config_yml( app )
      path = app.paths["config/redis"].first

      require 'erb'
      config = YAML.load ERB.new( IO.read( path ) ).result

      if config.key?( Rails.env )
        { driver: :hiredis }.merge( config[Rails.env].symbolize_keys )
      else
        raise "There is no Redis config for the #{Rails.env.inspect} environment in "\
              "#{app.paths["config/redis"].first}.\nEither add one or set your Redis URL " \
              "with an ENV variable like REDIS_URL."
      end
    rescue Psych::SyntaxError => e
      raise "YAML syntax error occurred while parsing #{app.paths["config/redis"].first}. " \
            "Please note that YAML\nmust be consistently indented using spaces. Tabs are " \
            "Tabs are not allowed.\nError: #{e.message}"
    end
  end
end

