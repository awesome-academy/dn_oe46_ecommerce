class AdminController < ApplicationController
  before_action :logged_in_user, :check_admin?
  layout "admin"
end
