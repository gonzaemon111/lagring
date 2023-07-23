module Api
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception
    skip_before_action :verify_authenticity_token

    rescue_from ::InvalidParametersError, with: :rescue_error
    rescue_from ::NotFoundError, with: :rescue_error
    rescue_from ::UnauthorizedError, with: :rescue_error
    rescue_from ::JWT::VerificationError, with: :rescue_jwt_error
    rescue_from ::JWT::ExpiredSignature, with: :rescue_jwt_error

    def rescue_error(error)
      render(status: error.code || 400, json: { message: error.message, code: error.code, messages: error.details })
    end

    def rescue_jwt_error(error)
      if error.is_a?(::JWT::ExpiredSignature)
        render(status: :bad_request, json: { message: 'トークンの有効期限が切れています', code: 400, messages: [] })
      else
        render(status: :bad_request, json: { message: 'トークンが不正です', code: 400, messages: [] })
      end
    end

    def current_user
      @current_user ||= ::Users::DecodeTokenOperator.process(token:)
    end

    def token
      @token ||= request.headers['Authorization']&.split('Bearer ')&.reject(&:empty?)&.first
    end
  end
end
