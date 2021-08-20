require "rails_helper"

RSpec.describe Product, type: :model do
  let!(:category) {FactoryBot.create(:category, id: 1)}
  let!(:product_one) {FactoryBot.create(:product, category_id: 1, name: "a", price: 20)}
  let!(:product_two) {FactoryBot.create(:product, category_id: 1, name: "b", price: 23)}
  describe "associations" do
    it { should have_many_attached(:images) }
    it { should have_many(:orders) }
    it { should have_many(:order_items) }
    it { should belong_to(:category) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(Settings.validate.normal_length) }
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).only_integer }
    it do
      should validate_numericality_of(:quantity)
            .is_greater_than(Settings.validate.negative)
    end
    it { should validate_presence_of(:price) }
    it do
      should validate_numericality_of(:price)
            .is_greater_than(Settings.validate.zero)
    end
  end

  describe "scope" do
    it "sort desc by create_time" do
      expect(Product.sort_desc_by_create_time).to eq([product_two, product_one])
    end
    it "sort asc by name" do
      expect(Product.sort_by_name(:asc)).to eq([product_one, product_two])
    end
    it "sort asc by price" do
      expect(Product.sort_by_price(:asc)).to eq([product_one, product_two])
    end
    it "filter product beetwen 10$ -> 21$ " do
      expect(Product.filter_product_by_price(10, 21)).to eq([product_one])
    end

    it "filter product by expensive price " do
      expect(Product.expensive_price).to eq([])
    end

    it "get list of product by list of category id" do
      expect(Product.list_by_category([1])).to eq([product_one, product_two])
    end

    it "get list of product by list of product id" do
      expect(Product.list_by_ids([product_one.id, product_two.id]))
                    .to eq([product_one, product_two])
    end

    it "search by name like 'a' " do
      expect(Product.search_by_name("a")).to eq([product_one])
    end

    it "get active product " do
      expect(Product.active).to eq([product_one, product_two])
    end
  end

  describe "#check_enought_quantity?" do
    it { expect(product_one.check_enought_quantity?(15)).to be true }
  end

  describe "#is_active?" do
    it { expect(product_one.is_active?).to eq(true) }
  end

  describe "#handle_order" do
    it "delete order and order item when update product delete_at field" do
      user = FactoryBot.create(:user)
      order = FactoryBot.create(:order, user_id: user.id)
      order.order_items.first.product.update!(delete_at: Time.zone.now)
      expect(Order.count).to eq(0)
    end
  end
end
