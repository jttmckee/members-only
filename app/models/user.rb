class User < ApplicationRecord
  has_many :posts, foreign_key: 'author_id'
  #Validations
  validates :name, length: {maximum: 50}, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, length: {maximum: 255}, presence: true,
    uniqueness: {case_sensitive: false}, format: {with: VALID_EMAIL_REGEX}
  validates :password, length: {in: 6..255}, allow_nil: true

  #bcrypt
  has_secure_password



  def remember_me
    token = SecureRandom.urlsafe_base64
    self.remember_digest = User.digest(token)
    save
    return token
  end

  def forget_me
    self.remember_digest = nil
    save
  end

  #class methods
  def User.digest(token)
    BCrypt::Password.create(token, cost:10)
  end
end
