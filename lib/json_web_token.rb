class JsonWebToken
  SECRET_KEY = "fnkdafklajldsjfa"

  # Encode payload into a JWT token
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  # Decode JWT token
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::ExpiredSignature
    nil # Token expired
  rescue JWT::DecodeError
    nil # Invalid token
  end
end
