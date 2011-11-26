require 'test_helper'

class CastbooksControllerTest < ActionController::TestCase
  setup do
    @castbook = castbooks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:castbooks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create castbook" do
    assert_difference('Castbook.count') do
      post :create, castbook: @castbook.attributes
    end

    assert_redirected_to castbook_path(assigns(:castbook))
  end

  test "should show castbook" do
    get :show, id: @castbook.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @castbook.to_param
    assert_response :success
  end

  test "should update castbook" do
    put :update, id: @castbook.to_param, castbook: @castbook.attributes
    assert_redirected_to castbook_path(assigns(:castbook))
  end

  test "should destroy castbook" do
    assert_difference('Castbook.count', -1) do
      delete :destroy, id: @castbook.to_param
    end

    assert_redirected_to castbooks_path
  end
end
