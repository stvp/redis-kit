require 'test_helper'

class TestRailsKit < ActiveSupport::TestCase
  def setup
    ENV["REDIS_URL"] = nil
  end

  def test_load_from_config_redis_yml
    re_initialize
    $redis.class.must_equal Redis
    $redis.client.id.must_equal "redis://localhost:6379/0"
    $redis.client.connect
    $redis.client.connection.class.must_equal Redis::Connection::Hiredis
  end

  def test_load_url_from_env_variable
    ENV["REDIS_URL"] = "redis://127.0.0.1:6379"
    re_initialize
    $redis.class.must_equal Redis
    $redis.client.id.must_equal "redis://127.0.0.1:6379/0"
    $redis.client.connect
    $redis.client.connection.class.must_equal Redis::Connection::Hiredis
  end
end

