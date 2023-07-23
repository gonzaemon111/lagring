class UnauthorizedError < ::BaseError
  def initialize(message = '権限がありません', details = ['権限がありません'])
    super(message, 401, details)
  end
end
