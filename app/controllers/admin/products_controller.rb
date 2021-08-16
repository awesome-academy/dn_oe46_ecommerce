class Admin::ProductsController < AdminController
  before_action :find_category, only: [:create, :update]
  before_action :find_product, only: [:edit, :update, :destroy]

  def new
    @product = Product.new
  end

  def edit; end

  def index
    @products = Product.active.sort_desc_by_create_time.page(params[:page])
                       .includes(:category).per(Settings.product.admin_per_page)
  end

  def create
    @product = @category.products.build(product_params)
    if @product.save
      flash[:success] = t "product.create_success"
      redirect_to admin_products_path
    else
      render :new
    end
  end

  def update
    update_params = product_params
    update_params[:category_id] = @category.id
    if @product.update(update_params)
      flash[:success] = t "product.update_success"
      redirect_to admin_products_path
    else
      render :edit
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      @product.update!(delete_at: Time.zone.now)
      flash[:warning] = t "product.delete_success"
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = t "product.delete_error"
    ensure
      redirect_to admin_products_path
    end
  end

  private

  def product_params
    params.require(:product)
          .permit(:name, :description, :quantity, :price, images: [])
  end

  def find_category
    @category = Category.find_by(id: params[:product][:category_id])
    return if @category

    flash[:danger] = t "category.not_found"
    redirect_to new_admin_product_path
  end
end
