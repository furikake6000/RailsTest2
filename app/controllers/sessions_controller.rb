class SessionsController < ApplicationController
  def new()
  end

  def create()
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
        #ログイン成功
    else
        #ログインしっぱい
        if user
            #ユーザがいませんよ
            flash[:danger] = 'Invalid email'
        else
            #パスが間違ってますよ
            flash[:danger] = 'Invalid password combination'
        end
        #再度ログイン画面を描画
        render 'new'
    end
  end

  def destroy()

  end
end
