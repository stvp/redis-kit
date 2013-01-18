module RedisKit
  class Railtie < Rails::Railtie
    initializer "redis-kit.setup_redis" do |app|
      # Register the path with Rails so that users can change it, if they want.
      unless app.paths["config/redis"]
        app.paths.add "config/redis", with: "config/redis.yml"
      end

      # Set up a new global Redis connection.
      path = app.paths["config/redis"].first
      env = Rails.env
      $redis = Redis.new( RedisKit.load_config( path, env ) )
    end
  end
end

