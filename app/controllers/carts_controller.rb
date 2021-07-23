class CartsController < ApplicationController
  before_action :find_product, :get_line_item,
                only: [:add_to_cart, :update_to_cart, :delete_from_cart]
  before_action :get_quantity_for_add, only: [:add_to_cart]
  before_action :get_quantity_for_update, only: [:update_to_cart]
  before_action :check_quantity_params?, :check_enought_quantity?,
                only: [:add_to_cart, :update_to_cart]

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

  def update_to_cart
    if @line_item
      @line_item["quantity"] = params[:quantity].to_i
      flash.now[:success] = t "cart.update_quantity"
    else
      flash.now[:danger] = t "cart.error_update"
    end
    @cart_items = get_line_items_in_cart
    respond_to do |format|
      format.html{redirect_to carts_path}
      format.js
    end
  end

  def delete_from_cart
    if @line_item
      flash.now[:warning] = t "cart.delete_success"
      current_cart.delete(@line_item)
    else
      flash.now[:danger] = t "cart.error_delete"
    end
    @cart_items = get_line_items_in_cart
    respond_to do |format|
      format.html{redirect_to carts_path}
      format.js
    end
  end

  private

  def check_quantity_params?
    return if params[:quantity].to_i.positive?

    flash[:danger] = t "product.negative_quantity"
    redirect_to root_path
  end

  def check_enought_quantity?
    return if @product.check_enought_quantity? @quantity

    flash[:danger] = t "product.out_stock"
    redirect_to root_path
  end

  def get_line_item
    @line_item = find_line_item_in_cart @product
  end

  def get_quantity_for_add
    @quantity = if @line_item
                  @line_item["quantity"] + params[:quantity].to_i
                else
                  params[:quantity].to_i
                end
  end

  def get_quantity_for_update
    @quantity = params[:quantity].to_i
  end
end
