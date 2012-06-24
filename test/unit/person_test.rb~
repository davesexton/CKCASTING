require 'test_helper'
#TODO Add person unit test
class PersonTest < ActiveSupport::TestCase
  
  test "person attributes must not be empty" do
    person = Person.new
    assert person.invalid?
    assert person.errors[:first_name].any?
    assert person.errors[:last_name].any?
    assert person.errors[:gender].any?
    assert person.errors[:status].any?
  end
  
  test "gender must be male or female" do
    person = Person.new(first_name: 'Fred',
                        last_name: 'Bloggs',
                        status: 'Active')
    person.gender = 'xxxx'
    assert person.invalid?
    person.gender = 'Male'
    assert person.valid?
    person.gender = 'Female'
    assert person.valid?
  end

  test "status must be active or inactive" do
    person = Person.new(first_name: 'Fred',
                        last_name: 'Bloggs',
                        gender: 'Male')
    person.status = 'xxxx'
    assert person.invalid?
    person.status = 'Active'
    assert person.valid?
    person.status = 'Inactive'
    assert person.valid?
  end
  
  
end
