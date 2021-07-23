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
  scope :sort_desc_by_create_time, ->{order(created_at: :DESC)}
  scope :sort_by_name, ->(sort_type){order(name: sort_type)}
  scope :sort_by_price, ->(sort_type){order(price: sort_type)}
  scope :filter_product_by_price,
        ->(one, two){where("price BETWEEN ? AND ?", one, two)}
  scope :expensive_price, ->{where("price > ?", Settings.product.expensive)}
  scope :list_by_category, ->(list_id){where(category_id: list_id)}
  scope :list_by_ids, ->(list_id){where(id: list_id)}
  scope :search_by_name, ->(name){where("name LIKE '%#{name}%'")}

  def check_enought_quantity? quantity_params
    quantity_params.positive? && quantity >= quantity_params
  end
end
