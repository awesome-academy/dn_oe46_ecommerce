class Product < ApplicationRecord
  has_many_attached :images
  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items
  validates :name, presence: true,
                   length: {maximum: Settings.validate.normal_length}
  validates :quantity, presence: true, numericality:
                      {only_integer: true,
                       greater_than: Settings.validate.negative}
  validates :price, presence: true, numericality:
                       {greater_than: Settings.validate.zero}
  validates :images, content_type: {in: ["image/jpg", "image/jpeg",
                                    "image/png"],
                                    message: I18n.t("image_format")},
                     size:         {less_than: 5.megabytes,
                                    message: I18n.t("maximum_size")}
  scope :sort_desc_by_create_time, ->{order(created_at: :DESC)}
  scope :sort_by_name, ->(sort_type){order(name: sort_type)}
  scope :sort_by_price, ->(sort_type){order(price: sort_type)}
  scope :filter_product_by_price,
        ->(one, two){where("price BETWEEN ? AND ?", one, two)}
  scope :expensive_price, ->{where("price > ?", Settings.product.expensive)}
  scope :list_by_category, ->(list_id){where(category_id: list_id)}
  scope :list_by_ids, ->(list_id){where(id: list_id)}
  scope :search_by_name, ->(name){where("name LIKE '%#{name}%'")}
  scope :active, ->{where(delete_at: nil)}
  after_update :handle_order, if: :saved_change_to_delete_at?

  def check_enought_quantity? quantity_params
    quantity_params.positive? && quantity >= quantity_params
  end

  def is_active?
    delete_at.nil?
  end

  def handle_order
    orders.filter_pending_status.each do |item|
      item.order_items.destroy_by(product_id: id)
      item.destroy! if item.order_items.empty?
    end
  end
end
