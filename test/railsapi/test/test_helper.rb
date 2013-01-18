ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'

module TestHelpers
  def jruby?
    RUBY_ENGINE == "jruby"
  end

  def initialize_redis_kit
    Rails.application.initializers.select do |initializer|
      initializer.name =~ /redis-kit/
    end.each do |initializer|
      initializer.run( Rails.application )
    end
    $redis.client.connect
  end

  def get_socket( redis )
    case connection = redis.client.connection
    when Redis::Connection::Ruby
      connection.instance_variable_get( "@sock" )
    when Redis::Connection::Hiredis
      connection.instance_variable_get("@connection").sock
    else
      raise "#{connection} isn't a known connection type."
    end
  end

  def initialize_resque
    Resque.redis = $redis
    Resque.redis.client.connect
  end

  def resque_worker
    worker = Resque::Worker.new( :test )
    worker.term_child = "1"
    worker
  end
end

class ActiveSupport::TestCase
  include TestHelpers
  class << self
    include TestHelpers
  end
end

class TestResqueJob
  @queue = :test

  class << self
    include TestHelpers

    def perform
      $redis.ping
      $redis.set("socket", get_socket($redis).to_s)
    end
  end
end
