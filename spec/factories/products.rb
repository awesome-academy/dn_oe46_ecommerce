FactoryBot.define do
  factory :product do
    category_id { create(:category).id }
    name { Faker::Commerce.product_name }
    price { rand(10..50) }
    quantity { 20 }
    description { Faker::Lorem.paragraph }
  end
end
