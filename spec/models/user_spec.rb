require "rails_helper"

RSpec.describe User, type: :model do
  subject { FactoryBot.create :user }

  describe "associations" do
    it { should have_many(:orders) }
  end

  describe "validations" do
    it { should have_secure_password }
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

  describe ".new_token" do
    let(:new_token) {User.new_token}

    it "return a string" do
      expect(new_token).to be_kind_of String
    end

    it "has length 22 character" do
      expect(new_token.length).to eq(22)
    end
  end

  describe ".digest" do
    let(:digest) {User.digest("tranbao")}

    it "not nil" do
      expect(digest).not_to be nil
    end

    it "return a string" do
      expect(digest).to be_kind_of String
    end

    it "has length 60 character" do
      expect(digest.length).to eq(60)
    end
  end

  describe "#authenticated?" do
    it "false with nil password_digest" do
      subject.password_digest = nil
      expect(subject.authenticated?("password","tranbao")).to be false
    end

    it "true with correct password" do
      expect(subject.authenticated?("password","tranbao")).to be true
    end

    it "false with wrong password" do
      expect(subject.authenticated?("password","22012201")).to be false
    end
  end

  describe "#remember" do
    it "when remember digest nil" do
      expect(subject.remember_digest).to be nil
    end

    it "when update remember digest" do
      subject.remember
      expect(subject.remember_digest).not_to be nil
    end
  end

  describe "#forget" do
    it "update nil remember digest" do
      subject.remember
      subject.forget
      expect(subject.remember_digest).to be nil
    end
  end

  describe "#downcase_email" do
    it "is downcase email before save calllback" do
      subject.update!(email: "A@GMAIL.COM")
      expect(subject.reload.email).to eq("a@gmail.com")
    end
  end
end
