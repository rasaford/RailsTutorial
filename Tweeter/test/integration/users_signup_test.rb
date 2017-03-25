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
                email: "user@invalid",
                password: "foo",
                password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    # testing for the existance of error messages in the DOM
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
    # assert_routing({ path: 'signup', method: :post }, { controller: 'users', action: 'create' })
    assert_select 'form[action="/signup"]'
  end

  test 'valid user singnup' do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confimation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert_select "div.alert-success"
  end
end
