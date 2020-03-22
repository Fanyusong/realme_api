class AuthenticateUser
  prepend SimpleCommand

  def initialize(login, password)
    @login = login
    @password = password
  end

  def call
    if user
      {
        token: JsonWebToken.encode(user_id: user.id),
        user: user
      }
    end
  end

  private

  attr_accessor :login, :password

  def user
    find_user = User.where(phone_number: login, password: password)
    if find_user.any?
      user = find_user&.first
      return user if user
    end
    user = User.where(email: login, password: password)&.first
    return user if user
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end
end
