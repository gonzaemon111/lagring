class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from ::InvalidParametersError, with: :rescue_error
  rescue_from ::NotFoundError, with: :rescue_error

  def rescue_error(error)
    render(status: error.code || 400, json: { message: error.message, code: error.code, messages: error.details })
  end
end
