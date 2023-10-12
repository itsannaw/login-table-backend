class UsersController < ApplicationController
  include RackSessionsFix
  include ProcessToken
  wrap_parameters :user, include: [:full_name, :email, :password, :password_confirmation]

  before_action :process_token


  def index
    @users = User.all
    render json: @users
  end

  def name_users
    render json: current_user.full_name
  end

  def block_users
    users_ids = params[:users_ids]
    @users = User.where(id: users_ids).update_all(blocked: true)
    if users_ids.include?(current_user.id)
      sign_out(current_user)
      render json: { error: 'You have been blocked!' }, status: :unauthorized
    else
      render json: User.all
    end
  end

  def unblock_users
    users_ids = params[:users_ids]
    @users = User.where(id: users_ids).update_all(blocked: false)
    render json: User.all
  end

  def delete_users
    users_ids = params[:users_ids]
    is_in_list = users_ids.include?(current_user.id)
    @users = User.where(id: users_ids).destroy_all
    if is_in_list
      render json: { error: 'You have been deleted!' }, status: :unauthorized
    else
      render json: User.all
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end


    def user_params
      params.require(:user).permit(:full_name, :email, :password, :password_confirmation, :login_at, :blocked)
    end
end
