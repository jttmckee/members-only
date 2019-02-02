require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @count = User.count
    @user = User.new(name:'foobar',email:'example@example.com',
      password:'password', password_confirmation: 'password')
  end

  test "model saves correctly" do
    @user.save
    assert_equal(@count + 1, User.count)
  end

  test "model rejects mismatched passwords" do
    @user.password = 'wrong password'
    @user.save
    assert_equal(@count, User.count)
  end

  test "model rejects too short password" do
    @user.password = 'foo'
    @user.password_confirmation = 'foo'
    @user.save
    assert_equal(@count, User.count)
  end

  test "model rejects blank password" do
    @user.password = '   '
    @user.password_confirmation = '   '
    @user.save
    assert_equal(@count, User.count)
  end

  test "model rejects nil password" do
    @user.password = nil
    @user.password_confirmation = nil
    @user.save
    assert_equal(@count, User.count)
  end

  test "model rejects nil email address" do
    @user.email = nil
    @user.save
    assert_equal(@count, User.count)
  end

  test "model rejects invalid email address" do
    @user.email = 'hello@'
    @user.save
    assert_equal(@count, User.count)
  end

  test "model rejects non unique email address" do
    @user.save
    user2 = User.new(email: @user.email, name:"User num2", password: 'password',
      password_confirmation: 'password')
    user2.save
    assert_equal(@count+1, User.count)
  end
end
