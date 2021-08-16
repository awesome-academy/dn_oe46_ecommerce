class Order < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  enum status: {pending: 0, approve: 1, deny: 2, cancel: 3}
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  validates :full_name, presence: true,
                       length: {maximum: Settings.validate.normal_length}
  validates :email, presence: true,
                    length: {maximum: Settings.validate.normal_length},
                    format: {with: VALID_EMAIL_REGEX}
  validates :phone, numericality: {only_integer: true},
                    length: {maximum: Settings.validate.phone_length}
  validates :address, presence: true,
                      length: {maximum: Settings.validate.high_length}
  after_create :check_order_items?
  scope :sort_by_created_at, ->(sort_type){order(created_at: sort_type)}
  scope :filter_pending_status, ->{where(status: :pending)}

  def total_price
    order_items.pluck(:total_price).sum
  end

  def rollback_quantity
    order_items.each do |item|
      item.product.update!(quantity: item.product.quantity + item.quantity)
    end
  end

  private

  def check_order_items?
    raise ActiveRecord::RecordInvalid unless order_items.count.positive?
  end
end
