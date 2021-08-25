require "rails_helper"

RSpec.describe User, type: :model do
  subject { FactoryBot.create :user }

  describe "associations" do
    it { should have_many(:orders) }
  end

  describe "validations" do
    it { should define_enum_for(:role).with([:user, :staff, :admin]) }
    it { should validate_presence_of(:full_name) }
    it { should validate_length_of(:full_name).is_at_most(Settings.validate.normal_length) }
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_most(Settings.validate.normal_length) }
    it { should allow_value("bao@gmail.com").for(:email) }
    it { should validate_length_of(:phone).is_at_most(Settings.validate.phone_length) }
    it { should validate_numericality_of(:phone).only_integer }
    it { should validate_presence_of(:address) }
    it { should validate_length_of(:address).is_at_most(Settings.validate.high_length) }
    it { should validate_length_of(:password).is_at_least(Settings.validate.min_pass) }
  end
end
