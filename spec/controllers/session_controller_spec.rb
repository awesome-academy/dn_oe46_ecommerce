=begin
require "rails_helper"
include SessionsHelper

RSpec.describe SessionsController,	type:	:controller	do
  let!(:user) {FactoryBot.create(:user)}
  describe "GET #new" do
    before do
      get :new
    end
    it "rendering template new" do
      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do
    context "success when valid attributes" do
      before do
        post :create, params: {
          session: {
            email: user.email,
            password: user.password
          }
        }
      end
      it "save user id to session" do
        expect(session[:user_id]).not_to be_nil
      end

      it "redirect to root_url" do
        expect(response).to redirect_to root_url
      end
    end

    context "error when invalid email" do
      before do
        post :create, params: {
          session: {
            email: "bao@gmail.com",
            password: user.password
          }
        }
      end

      it "assign @user" do
        expect(assigns(:user)).to be_nil
      end

      it "not save user id to session" do
        expect(session[:user_id]).to be_nil
      end

      it "flash danger" do
        expect(flash.now[:danger]).to eq(I18n.t("email.not_valid"))
      end

      it "rendering template new" do
        expect(response).to render_template "new"
      end
    end

    context "error when invalid password" do
      before do
        post :create, params: {
          session: {
            email: user.email,
            password: "no pass"
          }
        }
      end

      it "assign @user" do
        expect(assigns(:user)).not_to be_nil
      end

      it "not save user id to session" do
        expect(session[:user_id]).to be_nil
      end

      it "flash danger" do
        expect(flash.now[:danger]).to eq(I18n.t("password.not_valid"))
      end

      it "rendering template new" do
        expect(response).to render_template "new"
      end
    end
  end

  describe "DELETE #destroy" do
    context "success when valid attributes" do
      before do
        log_in user
        delete :destroy, params: {
          id: user.id
        }
      end

      it "delete user_id from session" do
        expect(session[:user_id]).to be_nil
      end

      it "redirect to root_url" do
        expect(response).to redirect_to root_path
      end
    end
  end

end
=end
