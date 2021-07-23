class Admin::OrdersController < AdminController
  before_action :find_order, only: [:show, :update_status]
  before_action :set_default_search_params
  before_action :check_status?, only: [:update_status]

  def index
    @q = Order.ransack(params[:q])
    @orders = @q.result.sort_by_created_at(:desc).page(params[:page])
                .per(Settings.order.per_page)
  end

  def show
    @order_items = @order.order_items.includes(:product)
                         .page(params[:page]).per(Settings.order_item.per_page)
    @page = params[:my_page]
  end

  def update_status
    ActiveRecord::Base.transaction do
      @order.update!(status: params[:status])
      @order.rollback_quantity if params[:status].eql?("deny")
      flash[:info] = t "order.status_success"
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = t "order.status_error"
    ensure
      redirect_to admin_orders_path(page: params[:page])
    end
  end

  private

  def find_order
    @order = Order.find_by(id: params[:id])
    return if @order

    flash[:danger] = t "order.not_found"
    redirect_to orders_path
  end

  def check_status?
    return if Order.statuses.keys.include?(params[:status])

    flash[:danger] = t "order.invalid_status"
    redirect_to orders_path
  end

  def set_default_search_params
    params[:q] ||= {status_eq: :pending}
  end
end
