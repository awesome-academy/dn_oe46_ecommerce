class StaticPagesController < ApplicationController
  before_action :get_list_product, only: [:sort]
  before_action :list_old_product, only: [:sort], if: :check_old_product?
  before_action :find_categories, only: [:home, :search, :sort]

  def home
    @products = Product.active.sort_desc_by_create_time
                       .page(params[:page]).per(Settings.product.per_page)
    @list_trend_product = OrderItem.get_trending_product
  end

  def sort
    @old_sort = params[:sort]
    @products = list_product(params[:sort]).page(params[:page])
                                           .per(Settings.product.per_page)
    respond_to do |format|
      format.html{render "static_pages/home"}
      format.js
    end
  end

  def search
    @products = Product.active.search_by_name(params[:search])
                       .page(params[:page]).per(Settings.product.per_page)
    render "static_pages/home"
  end

  private

  def get_list_product
    @list_old_product = Product.active.list_by_ids(params[:list_product_id])
  end

  def list_product sort_type
    case sort_type.to_i
    when Settings.sort_name_asc
      @list_old_product.sort_by_name(:ASC)
    when Settings.sort_name_desc
      @list_old_product.sort_by_name(:DESC)
    when Settings.sort_price_asc
      @list_old_product.sort_by_price(:ASC)
    when Settings.sort_price_desc
      @list_old_product.sort_by_price(:DESC)
    when Settings.filter_price_low
      @list_old_product.filter_product_by_price(0, 10)
    when Settings.filter_price_normal
      @list_old_product.filter_product_by_price(10, 30)
    when Settings.filter_price_medium
      @list_old_product.filter_product_by_price(30, 50)
    when Settings.filter_price_high
      @list_old_product.expensive_price
    else
      Product.sort_desc_by_create_time
    end
  end

  def list_old_product
    @list_old_product = list_product params[:old_sort]
  end

  def check_old_product?
    params[:old_sort].present? &&
      !(Settings.list_id.to_a.include?(params[:sort].to_i) &&
        Settings.list_id.to_a.include?(params[:old_sort].to_i))
  end

  def find_categories
    @categories = Category.parents
  end
end
