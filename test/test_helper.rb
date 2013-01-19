require_relative "../lib/redis-kit"
require 'minitest/spec'
require 'minitest/autorun'

def jruby?
  RUBY_ENGINE == "jruby"
end

def good_config_path
  "test/support/redis.good.yml"
end

def missing_config_path
  "test/support/whoops.yml"
end

def invalid_config_path
  "test/support/redis.invalid.yml"
end

def blank_config_path
  "test/support/redis.blank.yml"
end

def catch_error
  begin
    yield
    nil
  rescue => e
    return e
  end
end

