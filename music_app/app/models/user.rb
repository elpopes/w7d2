class User < ApplicationRecord
  before_validation :ensure_session_token
  validates :email, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }

  attr_reader :password

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)

    user&.is_password?(password) ? user : nil
  end

  def is_password?(password)
    BCrypta::Password.new(self.password_digest).is_password?(password)
  end

  def password=(pass)
    self.password_digest = BCrypt::Password.create(pass)
    @password = pass
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    return self.session_token
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end
end
