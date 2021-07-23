FactoryBot.define do
  factory :order do
    full_name { Faker::Name.name }
    address { Faker::Address.full_address}
    phone { "0877654121"}
    email { Faker::Internet.email}
    after(:build) do |order|
      order.order_items << build(:order_item, order: order)
    end
  end

  factory :order_with_no_order_item, class: Order do
    full_name { Faker::Name.name }
    address { Faker::Address.full_address}
    phone { "0877654121"}
    email { Faker::Internet.email}
  end
end
