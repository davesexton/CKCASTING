require 'test_helper'
#TODO add home functional tests
class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
