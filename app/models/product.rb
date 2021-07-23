class Product < ApplicationRecord
  has_many_attached :images
  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items
  validates :name, presence: true,
                   length: {maximum: Settings.validate.normal_length}
  validates :quantity, presence: true, numericality:
                      {only_integer: true, greater_than: Settings.validate.zero}
  validates :price, presence: true,
                    numericality: {greater_than: Settings.validate.zero}
end
