module OrdersHelper
  def status_color order
    case order.status
    when "pending"
      "yellow"
    when "approve"
      "green"
    when "deny"
      "red"
    else
      "brown"
    end
  end
end
