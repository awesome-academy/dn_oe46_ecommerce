require "rails_helper"

RSpec.describe OrderItem, type: :model do
  let!(:user) {FactoryBot.create :user}
  let!(:order) {FactoryBot.create(:order, user_id: user.id)}
  let(:product_one) {order.products.first}
  let(:order_item) {order.order_items.first}
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
        expect(order_item.unit_price).to eq(product_one.price)
      end

      it "get total price  before save " do
        expect(order_item.total_price).to eq(order_item.unit_price * order_item.quantity)
      end
    end
  end

  describe ".get_trending_product" do
    it { expect(OrderItem.get_trending_product).to eq([product_one]) }
  end

  describe "#change_product_quantity" do
    it do
      expect(product_one.quantity).to eq(19)
    end
  end

  describe "#change_product_quantity" do
    it "false while quantity of order items is invalid" do
      oi = order_item.update(quantity: 30)
      expect(oi).to eq(false)
    end
  end
end
