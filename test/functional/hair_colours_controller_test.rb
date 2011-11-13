require 'test_helper'

class HairColoursControllerTest < ActionController::TestCase
  setup do
    @hair_colour = hair_colours(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hair_colours)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hair_colour" do
    assert_difference('HairColour.count') do
      post :create, hair_colour: @hair_colour.attributes
    end

    assert_redirected_to hair_colour_path(assigns(:hair_colour))
  end

  test "should show hair_colour" do
    get :show, id: @hair_colour.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hair_colour.to_param
    assert_response :success
  end

  test "should update hair_colour" do
    put :update, id: @hair_colour.to_param, hair_colour: @hair_colour.attributes
    assert_redirected_to hair_colour_path(assigns(:hair_colour))
  end

  test "should destroy hair_colour" do
    assert_difference('HairColour.count', -1) do
      delete :destroy, id: @hair_colour.to_param
    end

    assert_redirected_to hair_colours_path
  end
end
