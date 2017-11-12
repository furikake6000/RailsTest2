require 'test_helper'

class UserTest < ActiveSupport::TestCase
    def setup
        @user = User.new(
            name: "Example User", 
            email: "user@example.com",
            password: "foobar",
            password_confirmation: "foobar")
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

    test "validtest:valid email addresses" do
        valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
            @user.email = valid_address
            assert @user.valid?, "#{valid_address.inspect} should be valid"
        end
    end

    test "validtest:invalid email addresses" do
        invalid_addresses = %w[user@example,com user_at_foo.org
                           foo@bar_baz.com foo@bar+baz.com]
        invalid_addresses.each do |invalid_address|
            @user.email = invalid_address
            assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
        end
    end

    test "validtest:same email addresses" do
        duplicate_user = @user.dup
        @user.save
        assert_not duplicate_user.valid?, "Same address should be invalid"
        duplicate_user.email = @user.email.upcase
        assert_not duplicate_user.valid?, "Upcase address should be invalid"
    end

    test "password should be present (nonblank)" do
        @user.password = @user.password_confirmation = " " * 6
        assert_not @user.valid?
    end

    test "password should have a minimum length" do
        @user.password = @user.password_confirmation = "a" * 5
        assert_not @user.valid?
    end

    test "authenticated? should return false for a user with nil digest" do
        #@user doesn't have remember_digest
        assert_not(@user.authenticated?(''))
    end
end
