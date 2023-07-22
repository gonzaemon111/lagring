class ErrorForm
  include ::ActiveModel::Model
  include ::ActiveModel::Attributes

  attribute :code, :integer, default: 400
  attribute :object
  attribute :messages

  # NOTE: object.errorsは, ActiveModel::Errorsオブジェクトで色々メソッドがあるのであとでググる
  def initialize(object:, code: 400)
    super
    self.code = code
    self.object = object
    self.messages = object.errors.map(&:message)
  end

  def format
    { code:, messages: }
  end

  def errors
    messages
  end
end
