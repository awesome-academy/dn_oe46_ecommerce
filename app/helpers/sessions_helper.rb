module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def log_in?
    current_user.present?
  end

  def log_out
    forget current_user
    session.delete(:user_id)
    @current_user = nil
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget user
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def logged_in_user
    return if log_in?

    store_location
    flash[:warning] = t "user.please_login"
    redirect_to new_session_path
  end
end
