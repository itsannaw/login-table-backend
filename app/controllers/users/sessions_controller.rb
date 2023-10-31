
class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  before_action :authenticate_user!, only: [:destroy] # Optional: Restrict this action to authenticated users

  def create
    user = User.find_by(email: params[:user][:email])
    if user && user.blocked
      render json: { error: 'Your account has been blocked. Please contact Admin Table administrator if you think this is an error.' }, status: :unauthorized
    elsif user && user.valid_password?(params[:user][:password])
      sign_in user
      user.update(login_at: Time.now)
      user.save(validate: false)
      render json: { token: generate_jwt(user) }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    sign_out(current_user)
    render json: { message: 'Logged out successfully' }
  end

  private

  def generate_jwt(user)
    payload = {
      user_id: user.id,
      exp: 1.week.from_now.to_i
    }
    JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key, 'HS256')
  end
end
