class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  enum role: {user: 0, staff: 1, admin: 2}
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
end
