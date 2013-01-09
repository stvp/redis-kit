ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  def re_initialize
    initializer.run( Rails.application )
  end

  def initializer
    Rails.application.initializers.find do |initializer|
      initializer.name == "redisgreen.setup_redis"
    end
  end
end

