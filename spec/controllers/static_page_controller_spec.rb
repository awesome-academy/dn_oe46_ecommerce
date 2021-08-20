require "rails_helper"
include SessionsHelper

RSpec.describe StaticPagesController,	type:	:controller	do
  let!(:product) {FactoryBot.create(:product, name: "b")}
  let!(:product1) {FactoryBot.create(:product, name: "a")}
  describe "GET #home" do
    before do
      get :home
    end

    it "assign @categories" do
      expect(assigns(:categories)).not_to be_nil
    end

    it "assign @products" do
      expect(assigns(:products)).not_to be_nil
    end

    it "assign @list_trend_product" do
      expect(assigns(:list_trend_product)).to be_empty
    end
  end

  describe "GET #search" do
    before do
      get :search , params: {
        search: product.name
      }
    end

    it "assign @products" do
      expect(assigns(:products)).not_to be_nil
    end

    it "render template home" do
      expect(response).to render_template("static_pages/home")
    end
  end

  describe "GET #sort" do
    before do
      get :sort , params: {
        sort: Settings.sort_name_asc,
        list_product_id: [product.id, product1.id]
      }
    end

    it "assign @products" do
      expect(assigns(:products)).to eq([product1, product])
    end
  end
end
