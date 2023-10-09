class UsersController < ApplicationController
  include RackSessionsFix
  wrap_parameters :user, include: [:full_name, :email, :password, :password_confirmation]
  before_action :set_user, only: %i[ show update destroy ]
  before_action :process_token

  def process_token
    if request.headers['Authorization'].present?
      begin
        jwt_payload = JWT.decode(
          request.headers['Authorization'].split(' ')[1].remove('"'),
          Rails.application.credentials.devise_jwt_secret_key
        ).first

        @current_user_id = jwt_payload['id']
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        head :unauthorized
      end
    else
      head :unauthorized
    end
  end

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)
    @user.blocked = false

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:full_name, :email, :password, :password_confirmation, :login_at, :blocked)
    end
end
