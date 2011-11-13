require 'test_helper'

class EyeColoursControllerTest < ActionController::TestCase
  setup do
    @eye_colour = eye_colours(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:eye_colours)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create eye_colour" do
    assert_difference('EyeColour.count') do
      post :create, eye_colour: @eye_colour.attributes
    end

    assert_redirected_to eye_colour_path(assigns(:eye_colour))
  end

  test "should show eye_colour" do
    get :show, id: @eye_colour.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @eye_colour.to_param
    assert_response :success
  end

  test "should update eye_colour" do
    put :update, id: @eye_colour.to_param, eye_colour: @eye_colour.attributes
    assert_redirected_to eye_colour_path(assigns(:eye_colour))
  end

  test "should destroy eye_colour" do
    assert_difference('EyeColour.count', -1) do
      delete :destroy, id: @eye_colour.to_param
    end

    assert_redirected_to eye_colours_path
  end
end
