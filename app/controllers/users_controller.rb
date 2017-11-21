class UsersController < ApplicationController
  #ユーザの削除は管理者じゃないとできない
  before_action :admin_user, only: :destroy
  #更新ページと更新、ユーザ一覧の閲覧はログインしていないとできない
  before_action :logged_in_user, only: [:edit, :update, :index]
  #正しいユーザでログインしていないとできない
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new()
  end

  def create
    @user = User.new(user_params())
    if @user.save()
      #新規登録に成功したらメール送信
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account!"
      redirect_to(root_url)
    else
      #新規登録に失敗したら
      #ページ描画し直し（欄を全て空白に）
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params())
      #更新に成功したら
      flash[:success] = "Successful updated!"
      redirect_to(@user)
    else
      #更新に失敗したら
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy()
    flash[:success] = "User deleted."
    redirect_to(users_url)
  end

  #ローカルなメソッド
  private
    def user_params()
        params.require(:user).permit(
            :name, 
            :email, 
            :password, 
            :password_confirmation)
    end

    #正しいユーザかどうか確認する
    def correct_user()
      @user = User.find(params[:id])
      
      #正しいユーザでなければトップページにリダイレクト
      redirect_to(root_url) unless current_user?(@user)
    end

    #管理者かどうか確認する
    def admin_user()
      #管理者でないかログインしてなければトップページにリダイレクト
      redirect_to(root_url) unless logged_in? && current_user.admin?
    end

    #正しいユーザ、もしくは管理者ならばパス
    def correct_user_or_admin()
      @user = User.find(params[:id])
      redirect_to(root_url) unless logged_in? && ( current_user.admin? || current_user?(@user) )
    end
end
