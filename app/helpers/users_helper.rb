module UsersHelper
  def check_admin?
    current_user.staff? || current_user.admin?
  end
end
