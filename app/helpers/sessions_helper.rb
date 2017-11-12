module SessionsHelper

    #渡されたユーザでログインする
    def log_in(user)
        session[:user_id] = user.id
    end

    #永続的セッションを破棄する
    def forget(user)
        user.forget()
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    #現在のユーザーをログアウトする
    def log_out()
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
    end

    #現在ログインしているユーザーを取得する
    def current_user()
        if (user_id = session[:user_id])
            #一時セッションがある場合
            @current_user ||= User.find_by(id: user_id)
        elsif (user_id = cookies.signed[:user_id] )
            #永続セッションがある場合(かつ一時セッションがない場合)
            user = User.find_by(id: user_id)
            if user && user.authenticated?(cookies[:remember_token])
                log_in(user)
                @current_user = user
            end
        end
    end

    #ログインしているかどうか返す
    def logged_in?()
        !current_user.nil?()
    end

    #ユーザを永続的セッションに保存する
    def remember(user)
        user.remember()
        #idは署名付きでセキュアに保存
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end
end