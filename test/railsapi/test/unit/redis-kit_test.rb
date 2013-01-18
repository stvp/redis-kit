require 'test_helper'

class TestRailsKit < ActiveSupport::TestCase
  def setup
    ENV["REDIS_URL"] = nil
    $redis.flushall
  end

  #
  # Configuration
  #

  def test_load_from_config_redis_yml
    initialize_redis_kit
    $redis.class.must_equal Redis
    $redis.client.id.must_equal "redis://localhost:6379/0"
    if jruby?
      $redis.client.connection.class.must_equal Redis::Connection::Ruby
    else
      $redis.client.connection.class.must_equal Redis::Connection::Hiredis
    end
  end

  def test_load_url_from_env_variable
    ENV["REDIS_URL"] = "redis://127.0.0.1:6379"
    initialize_redis_kit
    $redis.class.must_equal Redis
    $redis.client.id.must_equal "redis://127.0.0.1:6379/0"
    if jruby?
      $redis.client.connection.class.must_equal Redis::Connection::Ruby
    else
      $redis.client.connection.class.must_equal Redis::Connection::Hiredis
    end
  end

  #
  # Resque
  #

  unless jruby?
    def test_resque_using_same_connection
      initialize_redis_kit
      initialize_resque

      original_socket = get_socket( $redis ).to_s
      Resque.enqueue(TestResqueJob)
      resque_worker.work(0)
      Resque.redis.redis.must_equal $redis
      forked_socket = $redis.get("socket")
      forked_socket.must_match( /Socket:/ )

      # Resque reconnected to redis
      forked_socket.wont_equal original_socket
      # Still sharing the same connection
      get_socket( Resque.redis ).must_equal get_socket( $redis )
    end

    def test_resque_using_different_connection
      initialize_redis_kit
      initialize_resque
      initialize_redis_kit # New connection for $redis

      # Using 2 different connections
      $redis.wont_equal Resque.redis.redis

      original_socket = get_socket( $redis ).to_s
      Resque.enqueue(TestResqueJob)
      resque_worker.work(0)
      forked_socket = $redis.get("socket")
      forked_socket.must_match( /Socket:/ )

      # Resque reconnected to redis
      forked_socket.wont_equal original_socket
      # And we still have two different connections
      get_socket( Resque.redis ).wont_equal get_socket( $redis )
    end
  end
end
