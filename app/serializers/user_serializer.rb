class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :full_name, :blocked, :last_sign_in_at, :created_at
end
