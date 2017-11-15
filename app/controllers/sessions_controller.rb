class SessionsController < ApplicationController
  def new()
  end

  def create()
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
        #ログイン成功
        log_in(user)
        if params[:session][:remember_me] == '1'
          #cookieで記憶
          remember(user)
        else
          #cookieで記憶しないし、もししてたら消去する
          forget(user)
        end
        #既にリンク先が保存されていればそこに飛ぶ　そうでなければプロフページに飛ぶ
        redirect_back_or(user)
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
