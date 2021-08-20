FactoryBot.define do
  factory :order_item do
    product_id { create(:product).id }
    quantity { 1 }
  end
end
