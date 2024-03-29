require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user=User.new(name:"Boy", email:"boy@e.com",
                   password:"12345", password_confirmation: "12345")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "email should present" do
    @user.email = "  "
    assert_not @user.valid?
  end

  test "name should not be long" do
    @user.name = "a" *51
    assert_not @user.valid?
  end 

  test "email should not be long" do
    @user.email = "a" *256
    assert_not @user.valid?
  end

  test "email validation should accept valid adresses" do
    valid_adresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_adresses.each do |valid_adress|
      @user.email = valid_adress
      assert @user.valid?, "#{valid_adress.inspect} should be valid"
    end
  end

  test "invalid emails should be rejected" do
    invalid_adresses = %w[user@example,com user_at_foo.org user.name@example.
                          foo@bar_baz.com foo@bar+baz.com]
    invalid_adresses.each do |invalid_adress|
      @user.email = invalid_adress
      assert_not @user.valid?, "#{invalid_adress.inspect} should be invalid"
    end
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" *4
    assert_not @user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember,'')
  end

  test "micropost must be destroyed with user" do
    @user.save
    @user.microposts.create!(content:"Loren sucks")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test "feed should have the right posts" do
    michael = users(:michael)
    archer = users(:archer)
    lana = users(:lana)
    #Posts other
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    #Self post
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    #Post from unfollowed other
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(:post_unfollowed)
    end
  end
end
