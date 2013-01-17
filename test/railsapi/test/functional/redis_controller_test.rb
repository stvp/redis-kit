require 'test_helper'

class RedisControllerTest < ActionController::TestCase
  test "connects to redis" do
    get :index
    assert_response :success
    response.body.should == "true"
  end
end
