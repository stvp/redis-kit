ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'

class ActiveSupport::TestCase
  def re_initialize
    initializers.each do |initializer|
      initializer.run( Rails.application )
    end
  end

  def initializers
    Rails.application.initializers.select do |initializer|
      initializer.name =~ /redis-kit/
    end
  end
end

