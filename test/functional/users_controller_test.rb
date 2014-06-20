require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @input_attributes = {
      name: 'userfred',
      password: 'secret1A',
      password_confirmation: 'secret1A'
    }
    @user1 = users(:one)
    @user2 = users(:two)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: @input_attributes
    end
    assert_redirected_to users_path
  end

  test "should get edit" do
    get :edit, id: @user1
    assert_response :success
  end

  test "should update user" do
    put :update, id: @user1, user: @input_attributes
    assert_redirected_to users_path
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user1
    end

    assert_redirected_to users_path
  end
end
