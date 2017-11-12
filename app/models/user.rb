class User < ApplicationRecord

    attr_accessor(:remember_token)
    
    VALID_EMAIL_REGEX = /\A[a-zA-Z0-9_\#!$%&`'*+\-{|}~^\/=?\.]+@[a-zA-Z0-9][a-zA-Z0-9\.-]+\z/

    validates(:name, 
        presence:true, 
        length: {maximum:255}
        )
    validates(:email, 
        presence:true, 
        length: {maximum:255}, 
        format: { with: VALID_EMAIL_REGEX },
        uniqueness: { case_sensitive: false }
        )
    validates(:password,
        presence:true,
        length: {minimum:6})

    before_save{
        #小文字に
        self.email = self.email.downcase
    }

    has_secure_password

    #任意のStringに対するハッシュ化関数
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    #新トークン発行
    def User.new_token()
        SecureRandom.urlsafe_base64()
    end

    #リメンバトークンを発行してremember_tokenに格納する
    def remember()
        #新しいトークンの発行
        self.remember_token = User.new_token()
        #そのdigestをデータベースに保存
        update_attribute(:remember_digest, User.digest(self.remember_token))
    end

    #リメンバトークンの認証
    def authenticated?(remember_token)
        #is_password?()を使うとソルトを含めて認証してくれる
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
end
