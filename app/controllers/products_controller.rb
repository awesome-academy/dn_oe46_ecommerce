class ProductsController < ApplicationController
  before_action :find_product, only: [:show]
  before_action :find_category, only: [:index]

  def show; end

  def index
    @categories = Category.parents
    @products = Kaminari.paginate_array(Product
                        .list_by_category(list_children_id))
                        .page(params[:page]).per(Settings.product.per_page)
    render "static_pages/home"
  end

  private

  def find_category
    @category = Category.find_by(id: params[:category_id])
    return if @category

    flash[:danger] = t "category.not_found"
    redirect_to root_path
  end

  def list_children_id
    @category.descendants.pluck(:id) << @category.id
  end
end
