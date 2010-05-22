require 'test_helper'

class AuthenticationControllerTest < ActionController::TestCase
  test "should get admin_login" do
    get :admin_login
    assert_response :success
  end

  test "should get carrier_login" do
    get :carrier_login
    assert_response :success
  end

end
