class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  validates :quantity, presence: true, numericality:
                      {only_integer: true, greater_than: Settings.validate.zero}
  validate :product_present
  validate :order_present
  validate :enough_quantity
  before_save :finalize
  after_create :change_product_quantity

  def unit_price
    if persisted?
      self[:unit_price]
    else
      product.price
    end
  end

  def total_price
    unit_price * quantity
  end

  private

  def change_product_quantity
    product.update(quantity: product.quantity - quantity)
  end

  def finalize
    self.unit_price = unit_price
    self.total_price = total_price
  end

  def product_present
    return if product.present?

    errors.add(:product, t("product.not_valid"))
  end

  def order_present
    return if order.present?

    errors.add(:order, t("order.not_valid"))
  end

  def enough_quantity
    return if product.quantity >= quantity

    errors.add(:base, I18n.t("order_item.not_enough_quantity"))
  end
end
