require 'test_helper'

class RedisControllerTest < ActionController::TestCase
  def test_returns_good_response
    get :ping
    response.success?.must_equal true
    response.body.must_equal "true"
  end
end
