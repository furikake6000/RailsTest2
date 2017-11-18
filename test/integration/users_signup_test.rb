require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
    def setup
        ActionMailer::Base.deliberies.clear
    end

    test "invalid signup information" do
        get signup_path
        #ユーザが増えないことを確認
        assert_no_difference 'User.count' do
            post users_path, params: { user: {
                name: "",
                email: "user@invalid",
                password: "foo",
                password_confirmation: "bar" } }
        end
        #ページが遷移「していない」ことを確認
        assert_template 'users/new'
        #エラーダイアログの存在
        assert_select 'div#error_explanation'
        assert_select 'div.alert-danger'
    end

    test "valid signup information with account activation" do
        get signup_path
        #ユーザが1増えることを確認
        assert_difference 'User.count', 1 do
            post users_path, params: { user:{
                name: "Example User",
                email: "user@example.com",
                password: "password",
                password_confirmation: "password" } }

            follow_redirect!
        end

        assert_equal(Action::Base.deliberies.size, 1)
        user = assigns(:user)
        assert_not(user.activated?())

        #activated前にログインしてみる
        log_in_as(user)
        assert_not(is_logged_in?())
        # 有効化トークンが不正な場合
        get edit_account_activation_path("invalid token", email: user.email)
        assert_not is_logged_in?
        # トークンは正しいがメールアドレスが無効な場合
        get edit_account_activation_path(user.activation_token, email: 'wrong')
        assert_not is_logged_in?
        # 有効化トークンが正しい場合
        get edit_account_activation_path(user.activation_token, email: user.email)
        assert user.reload.activated?
        follow_redirect!
        assert_template 'users/show'
        assert is_logged_in?
    end
end