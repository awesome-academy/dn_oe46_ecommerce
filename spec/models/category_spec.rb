require "rails_helper"

RSpec.describe Category, type: :model do
  let!(:parent) {FactoryBot.create(:category, id: 1)}
  let!(:children) {FactoryBot.create(:category, parent_id: 1)}
  describe "associations" do
    it { should have_many(:childrens) }
    it { should have_many(:products) }
    it { should belong_to(:parent).optional }
  end
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(Settings.validate.normal_length) }
  end
  describe "scope" do
    it "get categories have no children" do
      expect(Category.parents).to eq([parent])
    end
    it "get categories have children" do
      expect(Category.childrens).to eq([children])
    end
  end
  describe "#descendants" do
    it {expect(parent.descendants).to eq([children])}
  end
end
