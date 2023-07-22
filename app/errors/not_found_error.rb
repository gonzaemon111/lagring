class NotFoundError < ::BaseError
  def initialize(message = 'データがありません。', details = ['データがありません。'])
    super(message, 404, details)
  end
end
