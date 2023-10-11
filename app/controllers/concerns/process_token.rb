module ProcessToken
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
end
