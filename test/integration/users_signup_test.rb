require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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

    test "valid signup information" do
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

        #ページ遷移を確認
        assert_template 'users/show'
        #成功のWelcomeダイアログを確認
        assert_select 'div.alert-success'
    end
end