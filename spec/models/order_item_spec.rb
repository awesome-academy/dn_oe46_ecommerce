require "rails_helper"

RSpec.describe OrderItem, type: :model do
  let!(:category) {FactoryBot.create(:category)}
  let!(:product) {FactoryBot.create(:product, category_id: category.id, name: "a", price: 20)}
  let!(:user) {FactoryBot.create(:user)}
  let!(:order) {user.orders.build(FactoryBot.build(:order).as_json)}
  let!(:order_item) {order.order_items.build(product_id: product.id, quantity: 10)}
  let!(:save_user) {user.save!}

  describe "associations" do
    it { should belong_to(:product) }
    it { should belong_to(:order) }
  end


  describe "validations" do
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).only_integer }
    it do
      should validate_numericality_of(:quantity)
            .is_greater_than(Settings.validate.negative)
    end
  end

  describe "#finalize" do
    context "When save order item" do
      it "get unit price  before save " do
        expect(order_item.unit_price).to eq(product.price)
      end

      it "get total price  before save " do
        expect(order_item.total_price).to eq(order_item.unit_price * order_item.quantity)
      end
    end
  end

  describe ".get_trending_product" do
    it { expect(OrderItem.get_trending_product).to eq([product]) }
  end

  describe "#change_product_quantity" do
    it do
      expect(order_item.product.quantity).to eq(product.quantity - order_item.quantity)
    end
  end

  describe "#change_product_quantity" do
    it "false while quantity of order items is invalid" do
      oi = order_item.update(quantity: 30)
      expect(oi).to eq(false)
    end
  end
end
