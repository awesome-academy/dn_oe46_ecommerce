class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  enum role: {user: 0, staff: 1, admin: 2}
  has_many :orders, dependent: :destroy
  validates :full_name, presence: true,
                        length: {maximum: Settings.validate.normal_length},
                        allow_nil: true
  validates :email, presence: true,
                    length: {maximum: Settings.validate.normal_length},
                    format: {with: VALID_EMAIL_REGEX}, uniqueness: true,
                    allow_nil: true
  validates :phone, numericality: {only_integer: true},
                    length: {maximum: Settings.validate.phone_length},
                    allow_nil: true
  validates :address, presence: true,
                      length: {maximum: Settings.validate.high_length},
                      allow_nil: true
  validates :password, presence: true,
                       length: {minimum: Settings.validate.min_pass},
                       allow_nil: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
