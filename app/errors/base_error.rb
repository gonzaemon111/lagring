class BaseError < ::StandardError
  attr_reader :code, :details

  def initialize(message = '', code = 400, details = [])
    @code = code
    @details = details
    super(message)
  end
end
