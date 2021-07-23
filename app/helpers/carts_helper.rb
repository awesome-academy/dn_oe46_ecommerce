module CartsHelper
  def current_cart
    session[:cart] ||= Array.new
  end

  def find_line_item_in_cart product
    current_cart.find{|line_item| line_item["product_id"] == product.id}
  end

  def get_line_items_in_cart
    cart_items = []
    current_cart.each do |line_item|
      product = Product.find_by(id: line_item["product_id"])
      if product&.is_active?
        cart_items << {product: product, quantity: line_item["quantity"]}
      else
        current_cart.delete(line_item)
      end
    end
    cart_items
  end

  def line_total_price line_item
    line_item[:product].price.to_f * line_item[:quantity]
  end

  def total_price
    line_items = get_line_items_in_cart
    line_items.reduce(0){|a, e| a + e[:product].price.to_f * e[:quantity]}
  end
end
