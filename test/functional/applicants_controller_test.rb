require 'test_helper'

class ApplicantsControllerTest < ActionController::TestCase
  setup do
    @applicant = applicants(:good)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:applicants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create applicant" do
    assert_difference('Applicant.count') do
      post :create, applicant: { address_line_1: @applicant.address_line_1,
                                 address_line_2: @applicant.address_line_2,
                                 address_line_3: @applicant.address_line_3,
                                 address_line_4: @applicant.address_line_4,
                                 date_of_birth: @applicant.date_of_birth,
                                 email_address: @applicant.email_address,
                                 eye_colour: @applicant.eye_colour,
                                 film_credits: @applicant.film_credits,
                                 first_name: @applicant.first_name,
                                 gaurdian_name_1: @applicant.gaurdian_name_1,
                                 gaurdian_name_2: @applicant.gaurdian_name_2,
                                 gaurdian_name_3: @applicant.gaurdian_name_3,
                                 gaurdian_telephone_1: @applicant.gaurdian_telephone_1,
                                 gaurdian_telephone_2: @applicant.gaurdian_telephone_2,
                                 gaurdian_telephone_3: @applicant.gaurdian_telephone_3,
                                 gender: @applicant.gender,
                                 hair_colour: @applicant.hair_colour,
                                 height_feet: @applicant.height_feet,
                                 height_inches: @applicant.height_inches,
                                 last_name: @applicant.last_name,
                                 other_credits: @applicant.other_credits,
                                 postcode: @applicant.postcode,
                                 skills: @applicant.skills,
                                 stage_credits: @applicant.stage_credits,
                                 tv_credits: @applicant.tv_credits }
    end

    assert_redirected_to root_path #applicant_path(assigns(:applicant))
  end

  test "should show applicant" do
    get :show, id: @applicant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @applicant
    assert_response :success
  end

  test "should update applicant" do
    put :update, id: @applicant, applicant: { address_line_1: @applicant.address_line_1, address_line_2: @applicant.address_line_2, address_line_3: @applicant.address_line_3, address_line_4: @applicant.address_line_4, date_of_birth: @applicant.date_of_birth, email_address: @applicant.email_address, eye_colour: @applicant.eye_colour, film_credits: @applicant.film_credits, first_name: @applicant.first_name, gaurdian_name_1: @applicant.gaurdian_name_1, gaurdian_name_2: @applicant.gaurdian_name_2, gaurdian_name_3: @applicant.gaurdian_name_3, gaurdian_telephone_1: @applicant.gaurdian_telephone_1, gaurdian_telephone_2: @applicant.gaurdian_telephone_2, gaurdian_telephone_3: @applicant.gaurdian_telephone_3, gender: @applicant.gender, hair_colour: @applicant.hair_colour, height_feet: @applicant.height_feet, height_inches: @applicant.height_inches, last_name: @applicant.last_name, other_credits: @applicant.other_credits, postcode: @applicant.postcode, skills: @applicant.skills, stage_credits: @applicant.stage_credits, tv_credits: @applicant.tv_credits }
    assert_redirected_to applicant_path(assigns(:applicant))
  end

  test "should destroy applicant" do
    assert_difference('Applicant.count', -1) do
      delete :destroy, id: @applicant
    end

    assert_redirected_to applicants_path
  end
end
