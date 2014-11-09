require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup iformation" do
    get signup_path
    assert_no_difference 'User.count' do 
      post users_path, user: { name: "", email: "user@invalid",
                               password: "foo", password_confirmation:"notFoo" }
    end
    assert_template 'users/new'
    assert_select 'div#<CSS id for error explanation>'
    assert_select 'div.<CSS class for field with error>'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count' do 
      post users_path, user: { name: "Example", email: "user@valid.com",
                               password: "sucessed", password_confirmation:"sucessed" }
    end
    assert_template 'users/new'
    assert_not flash.FILL_IN
  end
end
