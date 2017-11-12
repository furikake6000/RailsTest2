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

    assert(is_logged_in?())

    #ページが遷移することを確認
    assert_redirected_to(@user)
    follow_redirect!()
    assert_template('users/show')
    #ログインリンクがないことを確認
    assert_select("a[href=?]", login_path, count:0)
    #ログアウトリンクが有ることを確認
    assert_select("a[href=?]", logout_path)
    #ユーザプロフへのリンクがあることを確認
    assert_select("a[href=?]", user_path(@user))

    #ログアウト
    delete(logout_path)
    assert_not(is_logged_in?())
    #メインページに戻る
    assert_redirected_to(root_url)
    follow_redirect!()

    #ログインリンクがあることを確認
    assert_select("a[href=?]", login_path)
    #ログアウトリンクがないことを確認
    assert_select("a[href=?]", logout_path, count:0)
    #ユーザプロフへのリンクがないことを確認
    assert_select("a[href=?]", user_path(@user), count:0)
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

  test "login correctly with two browser" do
    get(login_path)
    #正しいログイン情報
    post(login_path, params: {
      session: {
        email: @user.email, 
        password:"password"
        }})

    assert(is_logged_in?())

    #ページが遷移することを確認
    assert_redirected_to(@user)
    follow_redirect!()
    assert_template('users/show')

    #ログアウト
    delete(logout_path)
    assert_not(is_logged_in?())
    #メインページに戻る
    assert_redirected_to(root_url)

    #2番目のブラウザでログアウト
    delete(logout_path)
    follow_redirect!()

    #ログインリンクがあることを確認
    assert_select("a[href=?]", login_path)
    #ログアウトリンクがないことを確認
    assert_select("a[href=?]", logout_path, count:0)
    #ユーザプロフへのリンクがないことを確認
    assert_select("a[href=?]", user_path(@user), count:0)
  end
end
