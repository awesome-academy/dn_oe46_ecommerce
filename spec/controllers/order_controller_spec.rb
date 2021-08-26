require "rails_helper"

RSpec.shared_examples "user don't log in" do
  before {get :new}
  it "flash alert" do
    expect(flash[:alert]).not_to be_nil
  end

  it "redirect to login path" do
    expect(response.redirect?).to be true
  end
end

RSpec.describe OrdersController, type: :controller do
  let!(:user) {FactoryBot.create :user}
  let!(:order) {FactoryBot.create(:order, user_id: user.id)}
  let!(:product) {FactoryBot.create :product}

  describe "GET #new" do
    context "success when valid attributes" do
      context "when curren cart empty" do
        before do
          sign_in user
          get :new
        end

        it "assign @order" do
          expect(assigns(:order)).not_to be_nil
        end

        it "assign @cart_items " do
          expect(assigns(:cart_items).empty?).to be true
        end
      end

      context "when curren cart not empty" do
        before do
          session[:cart] = [{product_id: product.id, quantity: 1}]
          sign_in user
          get :new
        end

        it "assign @cart_items " do
          expect(assigns(:cart_items).empty?).to be false
        end
      end

      it_behaves_like "user don't log in"
    end
  end

  describe "POST #create" do
    let(:order_params) {FactoryBot.build(:order).as_json}

    context "success when valid attributes" do
      before do
        session[:cart] = [{product_id: product.id, quantity: 1}]
        sign_in user
        get :create, params: {
          order: order_params
        }
      end

      it "assign @orders " do
        expect(assigns(:order)).not_to be_nil
      end

      it "reduce product quantity after create order success" do
        expect(Product.find_by(id: product.id)&.quantity).to eq(product.quantity - 1)
      end

      it "assign @cart_items " do
        expect(assigns(:cart_items).empty?).to be false
      end

      it "flash success" do
        expect(flash[:success]).to eq(I18n.t("order.place_success"))
      end

      it "redirect root path" do
        expect(response).to redirect_to root_path
      end
    end

    context "error when invalid product quantity" do
      before do
        session[:cart] = [{product_id: product.id, quantity: 100}]
        sign_in user
        get :create, params: {
          order: order_params
        }
      end

      it "assign @orders " do
        expect(assigns(:order)).not_to be_nil
      end

      it "assign @cart_items " do
        expect(assigns(:cart_items).empty?).to be false
      end

      it "flash warning" do
        expect(flash[:warning]).to eq(I18n.t("product.please_update_quantity",
                                              name: product.name))
      end

      it "redirect cart path" do
        expect(response).to redirect_to carts_path
      end
    end
    context "error when invalid order params" do
      before do
        session[:cart] = [{product_id: product.id, quantity: 1}]
        sign_in user
        get :create, params: {
          order: {
            full_name: "",
            email: "",
            phone: "0877654121",
            address: "60 ngo si lien"
          }
        }
      end

      it "render :new" do
        expect(response).to render_template "new"
      end
    end

    it_behaves_like "user don't log in"
  end

  describe "GET #index" do
    context "success when valid attributes" do
      before do
        sign_in user
        get :index
      end

      it "assign @orders" do
        expect(assigns(:orders).count).to eq(1)
      end
    end

    it_behaves_like "user don't log in"
  end

  describe "PUT #update_status" do
    before { allow_any_instance_of(CanCan::ControllerResource).to receive(:load_and_authorize_resource){ nil } }
    context "fail when id order not found" do
      before do
        sign_in user
        put :update_status, params: {
          id: -10
        }
      end

      it "assign @Order" do
        expect(assigns(:order)).to be_nil
      end

      it "flash danger" do
        expect(flash[:danger]).to eq(I18n.t("order.not_found"))
      end

      it "redirect to order path" do
        expect(response).to redirect_to orders_path
      end
    end

    context "fail when invalid status params" do
      before do
        sign_in user
        put :update_status, params: {
          id: order.id,
          status: "no status"
        }
      end

      it "assign @Order" do
        expect(assigns(:order)).not_to be_nil
      end

      it "flash danger" do
        expect(flash[:danger]).to eq(I18n.t("order.invalid_status"))
      end
    end

    context "success when valid status attribute" do
      before do
        sign_in user
        put :update_status, params: {
          id: order.id,
          status: :cancel
        }
      end

      it "flash info" do
        expect(flash[:info]).to eq(I18n.t("order.cancel"))
      end

      it "roll back quantity" do
        expect(order.products.first.quantity).to eq(product.quantity)
      end

      it "redirect to order path" do
        expect(response).to redirect_to orders_path
      end
    end
  end
end
