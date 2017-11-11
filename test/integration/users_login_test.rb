require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login correctly" do
    get(login_path)
    #正しいログイン情報
    post(login_path, params: {
      session: {
        email: @user.email, 
        password:"password"
        }})

    #ページが遷移することを確認
    assert_redirected_to(@user)
    follow_redirect!
    assert_template('users/show')
    #ログインリンクがないことを確認
    assert_select("a[href=?]", login_path, count:0)
    #ログアウトリンクが有ることを確認
    assert_select("a[href=?]", logout_path)
    #ユーザプロフへのリンクがあることを確認
    assert_select("a[href=?]", user_path(@user))
  end

  test "login incorrectly" do
    get(login_path)
    assert_template('sessions/new')
    #間違ったログイン情報
    post(login_path, params: {
      session: {
        email:"", 
        password:""
        }})

    #ページが遷移しない確認
    assert_template('sessions/new')
    assert_not(flash.empty?)

    #ホームに戻る
    get(root_path)
    assert(flash.empty?)
  end
end
