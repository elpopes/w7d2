class User < ApplicationRecord
  before_validation :ensure_session_token
  validates :username, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }

  attr_reader :password

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)

    user&.is_password?(password) ? user : nil
  end

  def is_password?(password)
    BCrypta::Password.new(self.password_digest).is_password?(password)
  end

  def password=(pass)
    @password = pass
    self.password_digest = BCrypt::Password.create(pass)
  end
end
