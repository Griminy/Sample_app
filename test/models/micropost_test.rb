require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(content: "Loren sucks")
  end

  test "should be valid" do
    assert @micropost.valid?    
  end

  test "user_id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do 
    @micropost.content = " "
    assert_not @micropost.valid?
  end

  test "content length should be at most 140 char" do
    @micropost.content = 'a'*141
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal Micropost.first, microposts(:most_recent)
  end
end
