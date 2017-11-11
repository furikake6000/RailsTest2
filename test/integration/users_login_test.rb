require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "login incorrectly" do
      get(login_path)
      assert_template('sessions/new')
      #間違ったログイン情報
      post(login_path, params: {session: {email:"", password:""}})

      #ページが遷移しない確認
      assert_template('sessions/new')
      assert_not(flash.empty?)

      #ホームに戻る
      get(root_path)
      assert(flash.empty?)
  end
end
