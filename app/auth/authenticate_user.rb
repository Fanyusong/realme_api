class AuthenticateUser
  def initialize(login)
    @login = login
  end

  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_reader :login

  def user
    user = User.where(email: login).or(User.where(phone_number: login))
    return user if user
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end
end
