class InvalidParametersError < ::BaseError
  def initialize(message = 'パラメータが不正です。', details = [])
    super(message, 400, details)
  end
end
