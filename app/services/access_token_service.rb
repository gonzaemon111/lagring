class AccessTokenService
  attr_reader :secret_key, :algorithm

  def initialize
    @secret_key = ::Rails.application.credentials.secret_key_base
    @algorithm = ::Rails.application.credentials.jwt_algorithm
  end

  def generate_token(payload)
    ::JWT.encode(payload, secret_key, algorithm)
  end

  def decode(token)
    ::JWT.decode(token, secret_key, true, { algorithm: })
  end
end
