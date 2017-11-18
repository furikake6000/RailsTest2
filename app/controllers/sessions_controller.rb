class SessionsController < ApplicationController
  def new()
    #自動生成されるため特に挙動はない
  end

  def create()
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?()
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
        #ログインしっぱい（まだ認証されていない）
        flash[:warning] = "Account not activated.\nCheck your email for the activation link."
        redirect_to(root_url)
      end
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
