require 'test_helper'
require 'redis-kit/cache'

class CachedClass
  include RedisKit::Cache::Helper
  cache_timeout 600
  cache_namespace "foo"

  def self.run
    one = cached( "bar", 10 ) do
      "one"
    end
    two = cached( "biz" ) do
      "two"
    end
    one + two
  end

  def run
    one = cached( "baz", 10 ) do
      "one"
    end
    two = cached( "bix" ) do
      "two"
    end
    one + two
  end
end

describe RedisKit::Cache::Helper do
  before do
    RedisKit.redis = RedisKit.new_redis( good_config_path, "test_mock" )
  end

  it "provides helpers" do
    CachedClass.run.must_equal "onetwo"
    RedisKit.redis.get( "foo:bar" ).must_equal "one"
    RedisKit.redis.ttl( "foo:bar" ).must_equal 10
    RedisKit.redis.get( "foo:biz" ).must_equal "two"
    RedisKit.redis.ttl( "foo:biz" ).must_equal 600

    CachedClass.new.run.must_equal "onetwo"
    RedisKit.redis.get( "foo:baz" ).must_equal "one"
    RedisKit.redis.ttl( "foo:baz" ).must_equal 10
    RedisKit.redis.get( "foo:bix" ).must_equal "two"
    RedisKit.redis.ttl( "foo:bix" ).must_equal 600
  end
end

