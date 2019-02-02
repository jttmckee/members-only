class User < ApplicationRecord

  #Validations
  validates :name, length: {maximum: 50}, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, length: {maximum: 255}, presence: true,
    uniqueness: {case_sensitive: false}, format: {with: VALID_EMAIL_REGEX}
  validates :password, length: {in: 6..255}, allow_nil: true

  #bcrypt
  has_secure_password

end
