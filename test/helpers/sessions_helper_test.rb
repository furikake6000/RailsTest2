require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup()
    @user = users(:michael)
    #cookie保存
    remember(@user)
  end

  test "current_user returns right user when session is nil" do
    #この状態ではsessionにはcurrentuserは登録されていない
    assert_equal(@user, current_user())
    assert(is_logged_in?())
  end

  test "current_user returns nil when remember digest is wrong" do
    #新しく生成したトークンでサーバに保存してあるrememberdigestを強制上書き
    @user.update_attribute(:remember_digest, User.digest(User.new_token()))
    assert_nil(current_user)
  end
end