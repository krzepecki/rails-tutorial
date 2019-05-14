require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

def setup
  @user = users(:michael)
end

test "unsuccesful_edit" do
  get edit_user_path(@user)
  assert_template 'users/edit'
  patch user_path(@user), params: {user: {name: "",
                                          email: "invalid",
                                          password: "cip",
                                          password_confirmation: "nji"}}
  assert_template 'users/edit'
  assert_select "div.alert", "The form contains 4 errors."
end

test "succesful_edit" do
  get edit_user_path(@user)
  assert_template 'users/edit'
  patch user_path(@user), params: { user: { name:  name,
                                            email: "email@email.com",
                                            password:              "",
                                            password_confirmation: "" } }
  assert_not flash.empty?
  assert_redirected_to @user
  @user.reload
  assert_equal name, @user.name
end

end
