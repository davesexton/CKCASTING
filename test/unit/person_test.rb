require 'test_helper'
#TODO Add person unit test
class PersonTest < ActiveSupport::TestCase

  test "person attributes must not be empty" do
    person = Person.new
    assert person.invalid?, 'record is invalid'
    assert person.errors[:last_name].any?, 'blank last name alowed'
    assert person.errors[:first_name].any?, 'blank first name allowed'
    assert person.errors[:gender].any?, 'blank gender allowed'
    assert_equal person.status, 'Active', 'new status does not default to Active'
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

#  test "fix test" do
#    person = Person.find(people(:good).id)
#    assert person.first_name == 'First', 'oh dear'
#  end

end
