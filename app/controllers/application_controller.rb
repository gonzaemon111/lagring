class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  after_action :record_access_log

  rescue_from ::InvalidParametersError, with: :rescue_error
  rescue_from ::NotFoundError, with: :rescue_error

  def routing_error
    ::Rails.logger.warn("#{params[:path]} was accessed. but that path doesn't exist.")
    raise ::NotFoundError, 'そのパスは存在しません'
  end

  def rescue_error(error)
    render(status: error.code || 400, json: { message: error.message, code: error.code, messages: error.details })
  end

  def record_access_log
    return unless ::Rails.env.production?

    ::Rails.logger.info({
      type: 'access',
      env: ::Rails.env.to_s,
      path: request.fullpath,
      params: request.params,
      ip: request.remote_ip,
      request_uuid: request.uuid,
      referer: request.referer,
      format: request.format,
      response_format: response.content_type,
      status: response.status
    }.to_json)
  end
end
