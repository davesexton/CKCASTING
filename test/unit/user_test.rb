require 'test_helper'
#TODO unit test for destroying all users
class UserTest < ActiveSupport::TestCase

  def setup
    @good_user = User.find(users(:one).id)
    @new_user = User.new
  end

  test "user name validations" do
    user = @new_user
    user.password = 'Aa123456'
    user.password_confirmation = 'Aa123456'

    user.name = 'userone'
    assert user.invalid?, 'duplicate user allowed'
    assert_equal 'has already been taken',
                 user.errors[:name].join(';')

    user.name = 'user'
    assert user.invalid?, 'short user name allowed'
    assert_equal 'must be at least 6 characters and contain only upper and lowercase letters',
                 user.errors[:name].join(';')

    user.name = 'user1xxx'
    assert user.invalid?, 'user name allows digits'
    assert_equal 'must be at least 6 characters and contain only upper and lowercase letters',
                 user.errors[:name].join(';')

    user.name = 'user-xxx'
    assert user.invalid?, 'user name allows punctuation'
    assert_equal 'must be at least 6 characters and contain only upper and lowercase letters',
                 user.errors[:name].join(';')

    user.name = 'davesexton'
    assert user.valid?, 'valid user name failed validation'
  end

  test "user password validations" do
    user = @new_user
    user.name = 'davesexton'

    user.password = 'Aa123456'
    user.password_confirmation = 'Aa123457'
    assert user.invalid?, 'password allows invalid confirmation'
    assert_equal 'doesn\'t match confirmation',
                 user.errors[:password].join(';')

    user.password = 'aa123456'
    user.password_confirmation = 'aa123456'
    assert user.invalid?, 'password allows no uppercase letters'
    assert_equal 'must contain at least one uppercase letter',
                 user.errors[:password].join(';')

    user.password = 'AA123456'
    user.password_confirmation = 'AA123456'
    assert user.invalid?, 'password allows no lowercase letters'
    assert_equal 'must contain at least one lowercase letter',
                 user.errors[:password].join(';')

    user.password = 'Aaaaaaaa'
    user.password_confirmation = 'Aaaaaaaa'
    assert user.invalid?, 'password allows no lowercase letters'
    assert_equal 'must contain at least one digit (0-9)',
                 user.errors[:password].join(';')

    user.password = 'Aa12345'
    user.password_confirmation = 'Aa12345'
    assert user.invalid?, 'short password allowed'
    assert_equal 'must be at least 8 characters long',
                 user.errors[:password].join(';')
  end
end
