require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "empty fields should raise errors" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: { name: "",
                email: "",
                password: "",
                password_confirmation: "" } }
    end
    assert_template 'users/new'
  end

  test "too short password" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: { name: "",
                email: "",
                password: "123",
                password_confirmation: "123" } }
    end
    assert_template 'users/new'
  end

  test "non matching password" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: { name: "",
                email: "",
                password: "12321",
                password_confirmation: "asdfas" } }
    end
    assert_template 'users/new'
  end

  test "inavid email" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: { name: "",
                email: "invalid@invalid:com",
                password: "",
                password_confirmation: "" } }
    end
    assert_template 'users/new'
  end
end
