class CartsController < ApplicationController
  before_action :find_product, :get_line_item, :check_enought_quantity?,
                only: [:add_to_cart]

  def index
    @cart_items = get_line_items_in_cart
  end

  def add_to_cart
    if @line_item
      @line_item["quantity"] += params[:quantity].to_i
      flash[:info] = t "cart.update_quantity"
    else
      current_cart << {product_id: @product.id,
                       quantity: params[:quantity].to_i}
      flash[:success] = t "cart.add_success"
    end
    session[:cart] = current_cart
    redirect_to root_path
  end

  private

  def check_enought_quantity?
    quantity = if @line_item
                 @line_item["quantity"] + params[:quantity].to_i
               else
                 params[:quantity].to_i
               end
    return if @product.check_enought_quantity? quantity

    flash[:danger] = t "product.out_stock"
    redirect_to root_path
  end

  def get_line_item
    @line_item = find_product_in_cart @product
  end
end
