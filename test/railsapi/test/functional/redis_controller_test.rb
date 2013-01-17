require 'test_helper'

class RedisControllerTest < ActionController::TestCase
  test "connects to redis" do
    get :ping
    assert_response :success
    assert response.body == "true"
  end
end
