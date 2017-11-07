require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  test "vaildtest" do
      assert @user.valid?
  end

  test "vaildtest:name" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "vaildtest:email" do
    @user.email = ""
    assert_not @user.valid?
  end
end
