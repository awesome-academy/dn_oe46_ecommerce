class User < ApplicationRecord
  attr_accessor :remember_token, :reset_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  before_save :downcase_email
  enum role: {user: 0, staff: 1, admin: 2}
  has_secure_password
  has_many :orders, dependent: :destroy
  validates :full_name, presence: true,
                        length: {maximum: Settings.validate.normal_length}
  validates :email, presence: true,
                    length: {maximum: Settings.validate.normal_length},
                    format: {with: VALID_EMAIL_REGEX}, uniqueness: true
  validates :phone, numericality: {only_integer: true},
                    length: {maximum: Settings.validate.phone_length}
  validates :address, presence: true,
                      length: {maximum: Settings.validate.high_length}
  validates :password, presence: true,
                       length: {minimum: Settings.validate.min_pass},
                       allow_nil: true
  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false unless digest

    BCrypt::Password.new(digest).is_password?(token)
  end

  def remember
    self.remember_token = User.new_token
    update_column(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
