class SessionsController < ApplicationController
  before_action :find_user, only: [:create]

  def new; end

  def create
    if @user.authenticate params[:session][:password]
      log_in @user
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      redirect_back_or root_url
    else
      flash.now[:danger] = t "password.not_valid"
      render :new
    end
  end

  def destroy
    log_out if log_in?
    redirect_to root_url
  end

  private

  def find_user
    @user = User.find_by(email: params[:session][:email].downcase)
    return if @user

    flash.now[:danger] = t "email.not_valid"
    render :new
  end
end
