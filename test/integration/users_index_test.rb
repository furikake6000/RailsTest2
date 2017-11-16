require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "index including pagination" do
    log_in_as(@user)
    get(users_path)
    assert_template('users/index')
    assert_select('div.pagination')
    User.paginate(page: 1).each do |user|
      #paginate:1のユーザ全てに対し、そのユーザのリンクが表示されていることを確認
      assert_select('a[href=?]', user_path(user), text:user.name)
    end
  end
end
