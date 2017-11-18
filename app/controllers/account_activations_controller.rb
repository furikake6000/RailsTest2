class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])

    #存在確認
    if !user
      flash[:danger] = "We cannot find such user."
      redirect_to(root_url)
      return
    end

    #既に認証されていたら
    if user.activated?()
      flash[:danger] = "This user has already activated."
      redirect_to(root_url)
      return
    end

    #URLのid(最後につくハッシュ化文字列)とactivation_digestを認証
    if user.authenticated?(:activation, params[:id])
      #成功
      user.activate
      log_in(user)

      flash[:success] = "Account activated"
      redirect_to(user)
    else
      #しっぱい
      flash[:danger] = "Invalid activation link"
      redirect_to(root_url)
    end
  end

end
