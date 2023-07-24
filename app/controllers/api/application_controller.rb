module Api
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception
    skip_before_action :verify_authenticity_token

    rescue_from ::InvalidParametersError, with: :rescue_error
    rescue_from ::NotFoundError, with: :rescue_error
    rescue_from ::UnauthorizedError, with: :rescue_error
    rescue_from ::JWT::VerificationError, with: :rescue_jwt_error
    rescue_from ::JWT::ExpiredSignature, with: :rescue_jwt_error
    rescue_from ::ActionController::ParameterMissing, with: :rescue_error

    def rescue_error(error)
      render(status: error.methods.include?(:code) ? error.code : 400,
             json: { message: error.message, code: error.methods.include?(:code) ? error.code : 400,
                     messages: error.methods.include?(:details) ? error.details : error.backtrace })
    end

    def rescue_server_error(error)
      render(status: :internal_server_error, json: { message: '予期せぬエラーが発生しました', code: 500, messages: error.backtrace })
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
      return @token if defined? @token

      header_token = request.headers['Authorization']&.split('Bearer ')&.reject(&:empty?)&.first
      raise ::UnauthorizedError, '権限がありません' unless header_token.present?

      @token = header_token
    end
  end
end
