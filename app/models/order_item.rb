class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  validates :quantity, presence: true,
                       numericality: {only_integer: true,
                                      greater_than: Settings.validate.negative}
  validate :enough_quantity, if: :product_present?
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

  def self.get_trending_product
    order_items_by_desc_quantity = OrderItem.group(:product_id)
                                            .sum(:quantity)
                                            .sort_by{|_, v| -v.to_i}
                                            .take(Settings.product.trend_size)
    list_trend_id = Hash[order_items_by_desc_quantity].keys
    Product.list_by_ids(list_trend_id)
  end

  private

  def change_product_quantity
    product.update!(quantity: product.quantity - quantity)
  end

  def finalize
    self.unit_price = unit_price
    self.total_price = total_price
  end

  def product_present?
    product.present?
  end

  def enough_quantity
    return if product.quantity >= quantity

    errors.add(:base, I18n.t("product.please_update_quantity",
                             name: product.name))
  end
end
