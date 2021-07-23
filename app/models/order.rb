class Order < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  enum status: {Pending: 0,
                Approve: 1,
                Deny: 2,
                Cancel: 3}
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  validates :fullname, presence: true,
                       length: {maximum: Settings.validate.normal_length}
  validates :email, presence: true,
                    length: {maximum: Settings.validate.normal_length},
                    format: {with: VALID_EMAIL_REGEX}
  validates :phone, numericality: {only_integer: true},
                    length: {maximum: Settings.validate.phone_length}
  validates :address, presence: true,
                      length: {maximum: Settings.validate.high_length}
end
