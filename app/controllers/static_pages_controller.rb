class StaticPagesController < ApplicationController
  def home
    @categories = Category.parents
    @products = Kaminari.paginate_array(Product.sort_desc_by_create_time)
                        .page(params[:page]).per(Settings.product.per_page)
  end
end
