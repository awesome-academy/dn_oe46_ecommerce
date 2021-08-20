require "rails_helper"

RSpec.describe Order, type: :model do
  let!(:user) {FactoryBot.create(:user)}
  let!(:order1) {FactoryBot.create(:order, user_id: user.id)}
  let!(:order2) {FactoryBot.create(:order, user_id: user.id)}

  describe "associations" do
    it { should have_many(:order_items) }
    it { should have_many(:products) }
    it { should belong_to(:user) }
  end


  describe "validations" do
    it { should define_enum_for(:status).with([:pending, :approve, :deny, :cancel]) }
    it { should validate_presence_of(:full_name) }
    it { should validate_length_of(:full_name).is_at_most(Settings.validate.normal_length) }
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_most(Settings.validate.normal_length) }
    it { should allow_value("bao@gmail.com").for(:email) }
    it { should validate_length_of(:phone).is_at_most(Settings.validate.phone_length) }
    it { should validate_numericality_of(:phone).only_integer }
    it { should validate_presence_of(:address) }
    it { should validate_length_of(:address).is_at_most(Settings.validate.high_length) }
  end

  describe "scope" do
    it "sort desc by created at" do
      expect(Order.sort_by_created_at(:desc)).to eq([order2, order1])
    end

    it "filter by pending status" do
      expect(Order.filter_pending_status).to eq([order1, order2])
    end
  end

  describe "#total_price" do
    it { expect(order1.total_price).to eq(order1.order_items.first.total_price) }
  end

  describe "#rollback_quantity" do
    it "update product quantity after cancel or deny order" do
      order1.rollback_quantity
      expect(order1.products.first.quantity).to eq(20)
    end
  end

  describe "#check_order_item" do
    it "false while create order have no order items" do
      order = FactoryBot.build(:order_with_no_order_item, user_id: user.id).save
      expect(order).to eq(false)
    end
  end
end
