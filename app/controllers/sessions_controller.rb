class SessionsController < ApplicationController
  def new()
  end

  def create()
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
        #ログイン成功
        log_in(user)
        remember(user)
        redirect_to(user)
    else
        #ログインしっぱい
        if user
            #ユーザがいませんよ
            flash.now[:danger] = 'Invalid email'
        else
            #パスが間違ってますよ
            flash.now[:danger] = 'Invalid password combination'
        end
        #再度ログイン画面を描画
        render 'new'
    end
  end

  def destroy()
    if logged_in?()
      log_out()
    end
    redirect_to(root_url)
  end
end
