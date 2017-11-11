module SessionsHelper

    #渡されたユーザでログインする
    def log_in(user)
        session[:user_id] = user.id
    end

    #現在のユーザーをログアウトする
    def log_out()
        session.delete(:user_id)
        @current_user = nil
    end

    #現在ログインしているユーザーを取得する
    def current_user
        @current_user ||= User.find_by(id: session[:user_id])
    end

    #ログインしているかどうか返す
    def logged_in?
        !current_user.nil?()
    end
end