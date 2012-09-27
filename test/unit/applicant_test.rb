require 'test_helper'
#TODO Add applicant unit tests
class ApplicantTest < ActiveSupport::TestCase

  def setup
    @new_applicant = Applicant.new
    @good_applicant = Applicant.find(applicants(:good).id)
  end

  test "applicant attributes must not be empty" do
    applicant = @new_applicant
    assert applicant.invalid?, 'invalid record is valid'

    assert applicant.errors[:last_name].any?, 'blank last name alowed'
    assert_equal "can't be blank",
                 applicant.errors[:last_name].join(';')

    assert applicant.errors[:first_name].any?, 'blank first name allowed'
    assert_equal "can't be blank",
                 applicant.errors[:first_name].join(';')

    assert applicant.errors[:email_address].any?, 'blank email address allowed'
    assert_equal "can't be blank",
                 applicant.errors[:email_address].join(';')

    assert applicant.errors[:email_address].any?, 'blank email address allowed'
    assert_equal "can't be blank",
                 applicant.errors[:email_address].join(';')

    assert applicant.errors[:date_of_birth].any?, 'blank date of birth allowed'
    assert_equal "can't be blank",
                 applicant.errors[:date_of_birth].join(';')

    #assert applicant.errors[:postcode].any?, 'blank postcode allowed'
    #assert_equal "can't be blank",
    #             applicant.errors[:postcode].join(';')

    assert applicant.errors[:address_line_1].any?, 'blank address line 1 allowed'
    assert_equal "can't be blank",
                 applicant.errors[:address_line_1].join(';')

    assert applicant.errors[:hair_colour].any?, 'blank hair_colour allowed'
    assert_equal "can't be blank",
                 applicant.errors[:hair_colour].join(';')

    assert applicant.errors[:eye_colour].any?, 'blank eye_colour allowed'
    assert_equal "can't be blank",
                 applicant.errors[:eye_colour].join(';')

    assert applicant.errors[:gaurdian_name_1].any?, 'blank gaurdian name allowed'
    assert_equal "can't be blank",
                 applicant.errors[:gaurdian_name_1].join(';')

  end

  test "gender must be male or female" do
    applicant = @good_applicant
    assert applicant.valid?
    applicant.gender = 'xxxx'
    assert applicant.invalid?, 'invalid gender allowed'
    applicant.gender = ''
    assert applicant.invalid?, 'invalid gender allowed'
    applicant.gender = nil
    assert applicant.invalid?, 'blank gender allowed'
    applicant.gender = 'Male'
    assert applicant.valid?, 'valid gender is invalid'
    applicant.gender = 'Female'
    assert applicant.valid?, 'valid gender is invalid'
  end

  test "postcode must be a valid format" do
    applicant = @good_applicant
    assert applicant.valid?
    applicant.postcode = 'xxx'
    assert applicant.invalid?, 'invalid postcode allowed'
    assert_equal "postcode is invalid",
                 applicant.errors[:postcode].join(';')

  end

end
