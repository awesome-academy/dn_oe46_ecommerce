module ProductsHelper
  def recently_ids
    cookies[:recently_ids] ||= Array.new
  end

  def add_recently_id
    list_id = if recently_ids.blank?
                Array.new
              else
                recently_ids.split("&")
              end
    list_id.unshift(@product.id) unless list_id.include?(@product.id.to_s)
    list_id.pop if list_id.length > Settings.product.recently_size
    cookies.permanent[:recently_ids] = list_id
  end

  def find_recently_products
    Product.list_by_ids(recently_ids.split("&"))
  end
end
