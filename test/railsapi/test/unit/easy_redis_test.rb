require 'test_helper'

class EasyRedisConfigYmlTest < ActiveSupport::TestCase
  test "load from redis.yml" do
    assert $redis.is_a?( Redis ), "creates a redis connection"
    assert $redis.client.id == "redis://localhost:6379/0", "use the settings from redis.yml"
    $redis.client.connect
    assert $redis.client.connection.is_a?( Redis::Connection::Hiredis ), "use hiredis by default"
  end
end

