require 'test_helper'
#TODO Add user unit test
class UserTest < ActiveSupport::TestCase

  def setup
    @user_one = User.find(users(:one).id)
    @user_two = User.find(users(:two).id)
  end

  test "user name must be unique" do
    user = User.new
    user.name = 'userone'
    user.password = 'password'
    assert user.invalid?

    assert_equal 'has already been taken',
                 user.errors[:name].join(';')
  end

  test 'password cannot be empty' do
    user = User.new
    user.name = 'dave'
    assert user.invalid?

    assert_equal "can't be blank",
                 user.errors[:password_digest].join(';')
  end

  test 'name cannot be empty' do
    user = User.new
    user.password = 'dave'
    assert user.invalid?

    assert_equal "can't be blank",
                 user.errors[:name].join(';')
  end
end
