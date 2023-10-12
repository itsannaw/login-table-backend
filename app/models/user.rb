class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :recoverable,
   :jwt_authenticatable, jwt_revocation_strategy: self
  validates :email, uniqueness: true, presence: true
  validates :full_name, presence: true
  validates :password_confirmation, presence: true
  validates :password, confirmation: {case_sensitive: true}

  validates_format_of :email,
    :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i,
  :multiline => true

  validates_presence_of    :password, :on=>:create
  validates_length_of    :password, :within => 1..20, :allow_blank => false

  def as_json(options={})
    options[:except] ||= [:password_digest]
    super(options)
  end

end
