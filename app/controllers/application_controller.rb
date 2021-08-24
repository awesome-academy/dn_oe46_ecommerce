class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  include CartsHelper
  include ProductsHelper
  include UsersHelper
  before_action :set_locale

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user|
      user.permit(:full_name, :email, :password, :phone, :address)
    end
    devise_parameter_sanitizer.permit(:account_update) do |user|
      user.permit(:full_name, :email, :password,
                  :current_password, :phone, :address)
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    return if @product

    flash[:danger] = t "product.not_found"
    redirect_to root_path
  end
end
