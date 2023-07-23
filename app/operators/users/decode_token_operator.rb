module Users
  class DecodeTokenOperator
    attr_reader :token

    private_class_method :new

    # @param [string] JWT
    # @return [User] ユーザー
    def self.process(token:)
      new(token).process
    end

    def initialize(token)
      @token = token
    end

    # @return [User] ユーザー
    # @return [Nil] ユーザーが存在しないかトークンの有効期限が切れている場合はnilを返す
    def process
      raise ::UnauthorizedError, 'トークンが不正です' unless decode_token.present?

      payload = decode_token[0].with_indifferent_access
      raise ::UnauthorizedError, 'トークンが不正です' unless payload.present? && payload[:exp].present? && payload[:email].present? && payload[:provider].present?

      raise ::UnauthorizedError, 'トークンの有効期限が切れています' if payload[:exp] < ::Time.current.to_i

      user = ::User.find_by(email: payload[:email], provider: payload[:provider])
      raise ::NotFoundError, 'ユーザーが存在しません' unless user.present?

      user
    end

    private

    def decode_token
      ::AccessTokenService.new.decode(token)
    end
  end
end
