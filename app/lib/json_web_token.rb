require 'jwt'

class JsonWebToken
  HMAC_SECRET = Rails.application.credentials.fetch(:secret_key_base)

  def self.encode(payload, exp = 15.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    body = JWT.decode(token, HMAC_SECRET)[0]
    HashWithIndifferentAccess.new body
  rescue JWT::ExpiredSignature, JWT::VerificationError => e
    raise ExceptionHandler::ExpiredSignature, e.message
  rescue StandardError => e
    return nil
  end
end