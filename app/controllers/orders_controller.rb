class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_order, only: [:update_status]
  before_action :check_status?, only: [:update_status]

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
    flash.empty? ? (render :new) : (redirect_to carts_path)
  end

  def index
    @orders = current_user.orders.sort_by_created_at(:desc)
                          .page(params[:page]).per(Settings.order.per_page)
  end

  def update_status
    ActiveRecord::Base.transaction do
      @order.update!(status: params[:status])
      @order.rollback_quantity
      flash[:info] = t "order.cancel"
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = t "order.cancel_error"
    ensure
      redirect_to orders_path(page: params[:page])
    end
  end

  private

  def find_order
    @order = Order.find_by(id: params[:id])
    return if @order

    flash[:danger] = t "order.not_found"
    redirect_to orders_path
  end

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

    flash[:warning] = t("product.please_update_quantity",
                        name: item[:product].name)
  end

  def check_status?
    return if Order.statuses.keys.include?(params[:status])

    flash[:danger] = t "order.invalid_status"
    redirect_to orders_path
  end
end
