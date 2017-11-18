class User < ApplicationRecord

    attr_accessor :remember_token, :activation_token 
    before_save :downcase_email
    before_create :create_activation_digest

    has_secure_password

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
        length: {minimum:6}, 
        allow_nil:true)

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

    #トークンの認証
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        #digestがnilだったらそもそもfalseを返す
        return false if digest.nil?
        #is_password?()を使うとソルトを含めて認証してくれる
        BCrypt::Password.new(digest).is_password?(token)
    end

    #リメンバトークンを削除する
    def forget()
        #データベースをnilで上書き
        update_attribute(:remember_digest, nil)
    end

    #アクティベート
    def activate
        update_attribute(:activated, true)
        update_attribute(:activated_at, Time.zone.now)
        update_columns(activated: true, activated_at: Time.zone.now)
    end

    #有効化用のメールを送信
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end

    private
        def downcase_email
            self.email = email.downcase
        end

        def create_activation_digest
            #アクティベーションコードを発行し、ダイジェストをDBに保存
            self.activation_token = User.new_token
            #この関数はDB作成前に実行されるため、ローカル変数は自動的にDBに格納される
            self.activation_digest = User.digest(activation_token)
        end
end
