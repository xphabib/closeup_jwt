class AuthenticateUser
  prepend SimpleCommand

  def initialize(login, password)
    @login = login
    @password = password
  end

  def call
    user = find_user
    p user
    if user
       JsonWebToken.encode(user_id: user.id)
    end
  end

  def self.get_token(user)
    JsonWebToken.encode(user_id: user.id)
  end

  def self.find_record(login)
    User.where("lower(email) = :value", {value: login}).first
  end

  private

  attr_accessor :login, :password

  def find_user
    user = User.where("lower(email) = :value", {value: login}).first
    return user if user && user.valid_password?(password)
    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end