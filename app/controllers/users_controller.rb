class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :find_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]
  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = t "page.welcome"
      redirect_to root_url
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash.now[:success] = t "user.success_update"
    else
      flash.now[:danger] = t "user.error_update"
    end
    render :edit
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :phone, :address,
                                 :password, :password_confirmation)
  end

  def find_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:danger] = t "user.not_found"
    redirect_to root_path
  end

  def correct_user
    return if @user == current_user

    flash[:danger] = t "user.incorrect_user"
    redirect_to root_path
  end
end
