class OrderItemsController < ApplicationController
  before_action :find_order, only: [:index]

  def index
    @order_items = @order.order_items.includes(:product)
                         .page(params[:page]).per(Settings.order_item.per_page)
    @page = params[:my_page]
  end

  private

  def find_order
    @order = Order.find_by(id: params[:order_id])
    return if @order

    flash[:danger] = t "order.not_found"
    redirect_to root_path
  end
end
