require 'test_helper'
class PersonTest < ActiveSupport::TestCase

  def setup
    @good_person = Person.find(people(:good).id)
    @new_person = Person.new
  end

  test "person attributes must not be empty" do
    person = @new_person
    assert person.invalid?, 'invalid record is valid'

    assert person.errors[:last_name].any?, 'blank last name alowed'
    assert_equal "can't be blank",
                 person.errors[:last_name].join(';')

    assert person.errors[:first_name].any?, 'blank first name allowed'
    assert_equal "can't be blank",
                 person.errors[:first_name].join(';')

    assert person.errors[:gender].any?, 'blank gender allowed'
    assert_equal " is not a valid gender",
                 person.errors[:gender].join(';')

    assert_equal person.status, 'Active',
                                'new status does not default to Active'

    assert_equal person.height_inches, 0, 'new height in inches does not default to 0'
    assert_equal person.height_feet, 0, 'new height in feet does not default to 0'
  end

  test "gender must be male or female" do
    person = @good_person
    assert person.valid?
    person.gender = 'xxxx'
    assert person.invalid?, 'invalid gender allowed'
    person.gender = ''
    assert person.invalid?, 'invalid gender allowed'
    person.gender = nil
    assert person.invalid?, 'blank gender allowed'
    person.gender = 'Male'
    assert person.valid?, 'valid gender is invalid'
    person.gender = 'Female'
    assert person.valid?, 'valid gender is invalid'
  end

  test "status must be active or inactive" do
    person = @good_person
    person.status = 'xxxx'
    assert person.invalid?, 'invalid status allowed'
    person.status = nil
    assert person.invalid?, 'blank status allowed'
    person.status = 'Active'
    assert person.valid?, 'valid status is invalid'
    person.status = 'Inactive'
    assert person.valid?, 'valid satus is invalid'
  end

  test "height in inches must be between 0 and 11" do
    person = @good_person
    person.height_inches = -1
    assert person.invalid?, 'negative height in inches allowed'
    assert_equal 'Height in inches must be a whole number between 0 and 11',
                 person.errors[:height_inches].join(';')
    person.height_inches = 12
    assert person.invalid?, 'over 11 inches in height allowed'
    assert_equal 'Height in inches must be a whole number between 0 and 11',
                 person.errors[:height_inches].join(';')
    person.height_inches = 1.5
    assert person.invalid?, 'non integer inches in height allowed'
    assert_equal 'Height in inches must be a whole number between 0 and 11',
                 person.errors[:height_inches].join(';')
    person.height_inches = 1
    assert person.valid?, 'valid height in inches is invalid'
  end

  test "height in feet must be between 0 and 7" do
    person = @good_person
    person.height_feet = -1
    assert person.invalid?, 'negative height in feet allowed'
    assert_equal 'Height in feet must be a whole number between 0 and 7',
                 person.errors[:height_feet].join(';')
    person.height_feet = 12
    assert person.invalid?, 'over 7 feet in height allowed'
    assert_equal 'Height in feet must be a whole number between 0 and 7',
                 person.errors[:height_feet].join(';')
    person.height_feet = 1.5
    assert person.invalid?, 'non integer feet in height allowed'
    assert_equal 'Height in feet must be a whole number between 0 and 7',
                 person.errors[:height_feet].join(';')
    person.height_feet = 1
    assert person.valid?, 'valid height in feet is invalid'
  end

  test "check urls are correct" do
    person = @good_person
    assert_equal "www.ckcasting.co.uk/castbook/cast/#{person.id}",
                  person.full_url,
                  'invalid full url'
    assert_equal "/castbook/cast/#{person.id}",
                  person.url,
                  'invalid full url'
    assert_equal "default_cast_image.jpg",
                  person.image_url,
                  'invalid image url'
    assert_equal "default_cast_image_thumb.jpg",
                  person.thumbnail_url,
                  'invalid thumbnail url'
  end

  test 'check age groups' do
    person = @good_person

    person.date_of_birth = Time.now.utc - 3.years + 1.day
    assert_equal 'Under 3 years', person.age_group
    assert_equal 0, person.age_group_id

    person.date_of_birth = Time.now.utc - 3.years
    assert_equal 'Under 3 years', person.age_group
    assert_equal 0, person.age_group_id

    person.date_of_birth = Time.now.utc - 3.years - 1.day
    assert_equal '3 - 6 years', person.age_group
    assert_equal 1, person.age_group_id

    person.date_of_birth = Time.now.utc - 6.years + 1.day
    assert_equal '3 - 6 years', person.age_group
    assert_equal 1, person.age_group_id

    person.date_of_birth = Time.now.utc - 6.years
    assert_equal '3 - 6 years', person.age_group
    assert_equal 1, person.age_group_id

    person.date_of_birth = Time.now.utc - 6.years - 1.day
    assert_equal '6 - 9 years', person.age_group
    assert_equal 2, person.age_group_id

    person.date_of_birth = Time.now.utc - 9.years + 1.day
    assert_equal '6 - 9 years', person.age_group
    assert_equal 2, person.age_group_id

    person.date_of_birth = Time.now.utc - 9.years
    assert_equal '6 - 9 years', person.age_group
    assert_equal 2, person.age_group_id

    person.date_of_birth = Time.now.utc - 9.years - 1.day
    assert_equal '9 - 12 years', person.age_group
    assert_equal 3, person.age_group_id

    person.date_of_birth = Time.now.utc - 12.years + 1.day
    assert_equal '9 - 12 years', person.age_group
    assert_equal 3, person.age_group_id

    person.date_of_birth = Time.now.utc - 12.years
    assert_equal '9 - 12 years', person.age_group
    assert_equal 3, person.age_group_id

    person.date_of_birth = Time.now.utc - 12.years - 1.day
    assert_equal '12 - 15 years', person.age_group
    assert_equal 4, person.age_group_id

    person.date_of_birth = Time.now.utc - 15.years + 1.day
    assert_equal '12 - 15 years', person.age_group
    assert_equal 4, person.age_group_id

    person.date_of_birth = Time.now.utc - 15.years
    assert_equal '12 - 15 years', person.age_group
    assert_equal 4, person.age_group_id

    person.date_of_birth = Time.now.utc - 15.years - 1.day
    assert_equal '15 - 18 years', person.age_group
    assert_equal 5, person.age_group_id

    person.date_of_birth = Time.now.utc - 18.years + 1.day
    assert_equal '15 - 18 years', person.age_group
    assert_equal 5, person.age_group_id

    person.date_of_birth = Time.now.utc - 18.years
    assert_equal '15 - 18 years', person.age_group
    assert_equal 5, person.age_group_id

    person.date_of_birth = Time.now.utc - 18.years - 1.day
    assert_equal 'Over 18 years', person.age_group
    assert_equal 6, person.age_group_id

    person.date_of_birth = Time.now.utc - 100.years
    assert_equal 'Over 18 years', person.age_group
    assert_equal 6, person.age_group_id

  end

  test 'check postcode format' do
    person = @good_person

    person.postcode = 'RMM6ESS'
    assert person.invalid?, 'Invalid postcode allowed'
    assert_equal "format is invalid",
                 person.errors[:postcode].join(';')

    person.postcode = 'RM66ES'
    assert person.valid?, 'Valid postcode with no space not allowed'

    person.postcode = 'WC1X 8UE'
    assert person.valid?, 'Valid west central postcode not allowed'

    person.postcode = 'RM6 6ES'
    assert person.valid?, 'Valid postcode not allowed'

  end

  test 'check hair colour groups' do
    person = @good_person

    person.hair_colour = 'Brown'
    assert_equal person.hair_colour_group, 'Brown'

    person.hair_colour = 'Light Brown'
    assert_equal person.hair_colour_group, 'Brown'

    person.hair_colour = 'Dark Brown'
    assert_equal person.hair_colour_group, 'Brown'
  end

  test 'check height groups' do
    person = @good_person

    person.height_feet = 2
    person.height_inches = 11
    assert_equal 'Under 3 foot', person.height_group
    assert_equal 0, person.height_group_id

    person.height_feet = 3
    person.height_inches = 0
    assert_equal '3 - 4 foot', person.height_group
    assert_equal 1, person.height_group_id

    person.height_feet = 3
    person.height_inches = 11
    assert_equal '3 - 4 foot', person.height_group
    assert_equal 1, person.height_group_id

    person.height_feet = 4
    person.height_inches = 0
    assert_equal '4 - 5 foot', person.height_group
    assert_equal 2, person.height_group_id

    person.height_feet = 4
    person.height_inches = 11
    assert_equal '4 - 5 foot', person.height_group
    assert_equal 2, person.height_group_id

    person.height_feet = 5
    person.height_inches = 0
    assert_equal '5 - 6 foot', person.height_group
    assert_equal 3, person.height_group_id

    person.height_feet = 5
    person.height_inches = 11
    assert_equal '5 - 6 foot', person.height_group
    assert_equal 3, person.height_group_id

    person.height_feet = 6
    person.height_inches = 0
    assert_equal 'Over 6 foot', person.height_group
    assert_equal 4, person.height_group_id
  end

  test 'test date of birth' do
    person = @good_person
    person.date_of_birth = Time.now.utc.to_date
    assert person.invalid?, 'date of birth can be greater than today'
    assert_equal "date of birth can't be greater than today",
                 person.errors[:date_of_birth].join(';')
    person.date_of_birth = Time.now.utc.to_date - 100.years
    assert person.invalid?, 'date of birth can be more than 100 years in the past'
    assert_equal "date of birth can't be more than 100 years in the past",
                 person.errors[:date_of_birth].join(';')
  end

  test 'check location position' do
    person = @good_person
    person.latitude = nil
    person.longitude = nil
    person.postcode = 'RM16 6ES'
    person.save
    assert_equal 51.4901008605957, person.latitude, 'incorrect latitude'
    assert_equal 0.30873599648475647, person.longitude, 'incorrect longitude'
    person.latitude = nil
    person.longitude = nil
    person.postcode = 'xxxxzyx'
    person.save
    assert_equal nil, person.latitude, 'incorrect latitude'
    assert_equal nil, person.longitude, 'incorrect longitude'

  end

  test 'check skill list' do
    person = @good_person
    person.skills.destroy_all
    person.skills.create(display_order: 1, skill_text: 'Pole dancing')
    person.skills.create(display_order: 2, skill_text: 'Salsa')
    person.skills.create(display_order: 3, skill_text: 'Cake making')
    assert_equal 'Pole dancing, Salsa, Cake making', person.skill_list
  end


end
