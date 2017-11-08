class User < ApplicationRecord
    
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
        length: {mininmum:6})

    before_save{
        #小文字に
        self.email = self.email.downcase
    }

    has_secure_password
end
