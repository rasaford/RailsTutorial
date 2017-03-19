require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "Test User", email: "user@example.org",
                    password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "e" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid email addresses" do
    valid_addresses = %w[user@example.com USER@foo.com A_US-ER@foo.bar.org
                      first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |adr|
      @user.email = adr
      assert @user.valid?, "#{adr.inspect} should be valid"
    end
  end

  test "email validation should reject invalid email addresses" do
    invalid_addresses = %w[user@example,com USER_at_foo.com user.name@example.foo@bar_baz.com
                      foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |adr|
      @user.email = adr
      assert_not @user.valid?, "#{adr.inspect} should be ivalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email.upcase!
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be saved as lower-case" do
    mixed = "Foo@ExAMPle.com"
    @user.email = mixed
    @user.save
    assert_equal mixed.downcase, @user.reload.email
  end
end
