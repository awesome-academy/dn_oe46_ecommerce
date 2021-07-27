class ProductsController < ApplicationController
  before_action :find_product, only: [:show]

  def show; end

  private

  def find_product
    @product = Product.find_by(id: params[:id])
    return if @product

    flash[:danger] = t "product.not_found"
    redirect_to root_path
  end
end
