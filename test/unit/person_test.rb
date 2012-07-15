require 'test_helper'
#TODO Add person unit test
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

#  test "fix test" do
#    person = Person.find(people(:good).id)
#    assert person.first_name == 'First', 'oh dear'
#  end

end
