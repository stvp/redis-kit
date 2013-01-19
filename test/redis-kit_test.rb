require_relative "test_helper"

describe "RedisKit.load_config" do
  after do
    ENV["REDIS_URL"] = nil
  end

  it "loads config from an environment variable" do
    ENV["REDIS_URL"] = "redis://cool.dude:12345"
    config = RedisKit.load_config( good_config_path, "test" )
    if jruby?
      config.must_equal url: "redis://cool.dude:12345"
    else
      config.must_equal driver: :hiredis, url: "redis://cool.dude:12345"
    end
  end

  it "loads config from a config file" do
    config = RedisKit.load_config( good_config_path, "test" )
    if jruby?
      config.must_equal url: "redis://good:1234", mock: false
    else
      config.must_equal driver: :hiredis, url: "redis://good:1234", mock: false
    end
  end

  it "supports ERB in the config file" do
    config = RedisKit.load_config( good_config_path, "test_erb" )
    if jruby?
      config.must_equal url: "redis://good:1234"
    else
      config.must_equal driver: :hiredis, url: "redis://good:1234"
    end
  end

  it "returns an error if the config file doesn't have a config for the environment" do
    catch_error do
      RedisKit.load_config( good_config_path, "whoops" )
    end.must_be_kind_of RedisKit::MissingConfigError
  end

  it "returns an error if the config file doesn't exist" do
    catch_error do
      RedisKit.load_config( missing_config_path, "test" )
    end.must_be_kind_of RedisKit::MissingConfigError
  end

  it "returns an error if the config file is blank" do
    catch_error do
      RedisKit.load_config( blank_config_path, "test" )
    end.must_be_kind_of RedisKit::MissingConfigError
  end

  it "returns an error if the config file is invalid" do
    catch_error do
      RedisKit.load_config( invalid_config_path, "test" )
    end.must_be_kind_of RedisKit::InvalidConfigSyntaxError
  end
end

describe "RedisKit.new_redis" do
  it "builds a regular redis connection" do
    redis = RedisKit.new_redis( good_config_path, "test" )
    redis.must_be_kind_of Redis
  end

  it "builds a mock redis connection" do
    redis = RedisKit.new_redis( good_config_path, "test_mock" )
    redis.must_be_kind_of MockRedis
  end
end

