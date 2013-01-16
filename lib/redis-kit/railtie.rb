require "redis"
require "hiredis"

module RedisKit
  class Railtie < Rails::Railtie
    initializer "redis-kit.setup_redis" do |app|
      unless app.paths["config/redis"]
        app.paths.add "config/redis", with: "config/redis.yml"
      end

      config = redis_configuration( app )
      $redis = Redis.new( config )
    end

    # Load Redis config from config/redis.yml
    def redis_configuration( app )
      path = app.paths["config/redis"].first

      require 'erb'
      config = YAML.load ERB.new( IO.read( path ) ).result

      if config.key?( Rails.env )
        { driver: :hiredis }.merge( config[Rails.env].symbolize_keys )
      else
        raise "There is no Redis config for the #{Rails.env.inspect} environment in" \
              "#{app.paths["config/redis"].first}. Either add one or set your Redis URL " \
              "with an ENV variable like REDIS_URL."
      end
    rescue Psych::SyntaxError => e
      raise "YAML syntax error occurred while parsing #{app.paths["config/redis"].first}. " \
            "Please note that YAML must be consistently indented using spaces. " \
            "Tabs are not allowed. Error: #{e.message}"
    end
  end
end

