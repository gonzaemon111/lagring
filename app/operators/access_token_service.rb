class AccessTokenService
  attr_reader :secret_key

  def initialize
    @secret_key = ::Rails.application.credentials.secret_key_base
  end

  def encode
    ::Rails.logger.debug secret_key
  end
end
