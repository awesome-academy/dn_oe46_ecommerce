class AdminController < ApplicationController
  before_action :authenticate_user!
  layout "admin"

  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = exception.message
    redirect_to root_path
  end
end
