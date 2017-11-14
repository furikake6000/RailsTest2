class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new()
  end

  def create
    @user = User.new(user_params())
    if @user.save()
      #新規登録に成功したら
      log_in(@user)
      flash[:success] = "Welcome to the Sample App!"
      redirect_to(user_url(@user))
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
    else
      #更新に失敗したら
      render 'edit'
    end
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
end
