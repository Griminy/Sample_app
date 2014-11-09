class User < ActiveRecord::Base
  before_save {email.downcase!}

  validates :name, presence: true, length: {maximum: 10 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 30 },
                    format: {with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, length: {minimum: 5 }
  has_secure_password
end