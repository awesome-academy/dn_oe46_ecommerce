class OrdersController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]

  def new
    @order = current_user.orders.build
    @cart_items = get_line_items_in_cart
  end

  def create
    ActiveRecord::Base.transaction do
      @order = current_user.orders.build
      @cart_items = get_line_items_in_cart
      create_order_items
      @order.assign_attributes(order_params)
      @order.save!
      flash[:success] = t "order.place_success"
      session[:cart] = nil
      redirect_to root_path
    end
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  private

  def order_params
    params.require(:order).permit(:full_name, :email, :phone, :address)
  end

  def create_order_items
    @cart_items.each do |item|
      check_enough_quantity(item)
      line_item = {product_id: item[:product].id, quantity: item[:quantity]}
      @order.order_items.build(line_item)
    end
  end

  def check_enough_quantity item
    return if item[:product].quantity >= item[:quantity]

    flash.now[:warning] = t("product.please_update_quantity",
                            name: item[:product].name)
  end
end
