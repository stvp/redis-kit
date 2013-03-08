require 'test_helper'
require 'redis-kit/cache'

describe RedisKit::Cache do
  before do
    RedisKit.redis = RedisKit.new_redis( good_config_path, "test_mock" )
  end

  after do
    RedisKit.redis.del "test:*"
  end

  it "caches values" do
    calculated = false
    value = RedisKit::Cache.get( "test:foo", 60 ) do
      calculated = true
      "yep"
    end
    value.must_equal "yep"
    calculated.must_equal true
    RedisKit.redis.ttl( "test:foo" ).must_equal 60

    # cache primed
    calculated = false
    value = RedisKit::Cache.get( "test:foo", 60 ) do
      calculated = true
      "yep"
    end
    value.must_equal "yep"
    calculated.must_equal false
  end
end

