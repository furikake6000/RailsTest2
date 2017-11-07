require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  test "vaildtest" do
      assert @user.valid?
  end

  test "vaildtest:nameblank" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "vaildtest:emailblank" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "vaildtest:nametoolong" do
    @user.name = "a" * 260
    assert_not @user.valid?
  end

  test "vaildtest:emailtoolong" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
end
