class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  validates :quantity, presence: true, numericality:
                      {only_integer: true, greater_than: Settings.validate.zero}
  validate :product_present
  validate :order_present

  private

  def product_present
    return if product.present?

    errors.add(:product, t("product.not_valid"))
  end

  def order_present
    return if order.present?

    errors.add(:order, t("order.not_valid"))
  end
end
