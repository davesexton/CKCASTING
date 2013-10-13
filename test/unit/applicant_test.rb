require 'test_helper'

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

    assert applicant.errors[:postcode].any?, 'blank postcode allowed'
    assert_equal "is invalid",
                 applicant.errors[:postcode].join(';')

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

    applicant.postcode = 'xxx'
    assert applicant.invalid?, 'invalid postcode allowed'
    assert_equal "is invalid",
                 applicant.errors[:postcode].join(';')

    applicant = @good_applicant
    applicant.postcode = 'RMM6ESS'
    assert applicant.invalid?, 'Invalid postcode allowed'

    applicant.postcode = 'RM66ES'
    assert applicant.valid?, 'Valid postcode with no space not allowed'

    applicant.postcode = 'WC1X 8UE'
    assert applicant.valid?, 'Valid west central postcode not allowed'

    applicant.postcode = 'RM6 6ES'
    assert applicant.valid?, 'Valid postcode not allowed'

  end

  test "telephone numbers must be a valid format" do
    applicant = @good_applicant
    assert applicant.valid?
    applicant.gaurdian_telephone_1 = 'xxx'
    assert applicant.invalid?, 'invalid gaurdian telephone 1 allowed'
    applicant.gaurdian_telephone_1 = '99-999-9999'
    assert applicant.invalid?, 'invalid gaurdian telephone 1 allowed'
    assert_equal "number is invalid",
                 applicant.errors[:gaurdian_telephone_1].join(';')
    applicant.gaurdian_telephone_1 = '0123-4567890'
    assert applicant.valid?

    applicant.gaurdian_telephone_2 = 'xxx'
    assert applicant.invalid?, 'invalid gaurdian telephone 2 allowed'
    applicant.gaurdian_telephone_2 = '99-999-9999'
    assert applicant.invalid?, 'invalid gaurdian telephone 2 allowed'
    assert_equal "number is invalid",
                 applicant.errors[:gaurdian_telephone_2].join(';')
    applicant.gaurdian_telephone_2 = '0123-4567890'
    assert applicant.valid?

    applicant.gaurdian_telephone_3 = 'xxx'
    assert applicant.invalid?, 'invalid gaurdian telephone 3 allowed'
    applicant.gaurdian_telephone_3 = '99-999-9999'
    assert applicant.invalid?, 'invalid gaurdian telephone 3 allowed'
    assert_equal "number is invalid",
                 applicant.errors[:gaurdian_telephone_3].join(';')
    applicant.gaurdian_telephone_3 = '0123-4567890'
    assert applicant.valid?

  end

end
