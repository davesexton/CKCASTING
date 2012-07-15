require 'test_helper'
#TODO Add age test
class PersonTest < ActiveSupport::TestCase

  test "person attributes must not be empty" do
    person = Person.new
    assert person.invalid?, 'invalid record is valid'
    assert person.errors[:last_name].any?, 'blank last name alowed'
    assert person.errors[:first_name].any?, 'blank first name allowed'
    assert person.errors[:gender].any?, 'blank gender allowed'
    assert_equal person.status, 'Active', 'new status does not default to Active'
    assert_equal person.height_inches, 0, 'new height in inches does not default to 0'
    assert_equal person.height_feet, 0, 'new height in feet does not default to 0'
  end

  test "gender must be male or female" do
    person = Person.find(people(:good).id)
    assert person.valid?
    person.gender = 'xxxx'
    assert person.invalid?, 'invalid gender allowed'
    person.gender = nil
    assert person.invalid?, 'blank gender allowed'
    person.gender = 'Male'
    assert person.valid?, 'valid gender is invalid'
    person.gender = 'Female'
    assert person.valid?, 'valid gender is invalid'
  end

  test "status must be active or inactive" do
    person = Person.find(people(:good).id)
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
    person = Person.find(people(:good).id)
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
    person = Person.find(people(:good).id)
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
    person = Person.find(people(:good).id)
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
    person = Person.find(people(:good).id)
    person.height_feet = 2
    person.height_inches = 11
    assert_equal 'Under 3 foot', person.height_group
    assert_equal 1, person.height_group_id
    person.height_feet = 3
    person.height_inches = 0
    assert_equal '3 - 4 foot', person.height_group
    assert_equal 2, person.height_group_id
    person.height_feet = 3
    person.height_inches = 11
    assert_equal '3 - 4 foot', person.height_group
    assert_equal 2, person.height_group_id
    person.height_feet = 4
    person.height_inches = 0
    assert_equal '4 - 5 foot', person.height_group
    assert_equal 3, person.height_group_id
    person.height_feet = 4
    person.height_inches = 11
    assert_equal '4 - 5 foot', person.height_group
    assert_equal 3, person.height_group_id
    person.height_feet = 5
    person.height_inches = 0
    assert_equal '5 - 6 foot', person.height_group
    assert_equal 4, person.height_group_id
    person.height_feet = 5
    person.height_inches = 11
    assert_equal '5 - 6 foot', person.height_group
    assert_equal 4, person.height_group_id
    person.height_feet = 6
    person.height_inches = 0
    assert_equal 'Over 6 foot', person.height_group
    assert_equal 5, person.height_group_id
  end
  test 'test date of birth' do
    person = Person.find(people(:good).id)
    person.date_of_birth = Time.now.utc.to_date
    assert person.invalid?, 'date of birth can be greater than today'
#    person.date_of_birth = Time.now.utc.to_date - 100.years
#    assert person.invalid?, 'date of birth can be more than 100 years in the past'
  end
end
