class User < ApplicationRecord
  has_secure_password
  validates :email, uniqueness: true
  validates :password, presence: true
  validates :password_confirmation, presence: true
  validates :password, confirmation: {case_sensitive: true}

  validates_format_of :email,
    :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i,
  :multiline => true

  def as_json(options={})
    options[:except] ||= [:password_digest]
    super(options)
  end
end
