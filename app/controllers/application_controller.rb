class ApplicationController < ActionController::Base
  load_and_authorize_resource
  include SessionsHelper
  include CartsHelper
  include ProductsHelper
  include UsersHelper
  before_action :set_locale

  private

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
