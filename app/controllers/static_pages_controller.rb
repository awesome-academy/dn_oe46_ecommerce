class StaticPagesController < ApplicationController
  def home
    @categories = Category.parents
    @products = Kaminari.paginate_array(Product.all)
                        .page(params[:page]).per(Settings.product.per_page)
  end
end
