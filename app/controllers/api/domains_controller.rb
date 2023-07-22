module Api
  class DomainsController < ApplicationController
    before_action :raise_error_if_not_found, only: %i[show update destroy]

    def index
      @domains = Domain.order(:updated_at)
      render json: { domains: @domains }, status: :ok
    end

    def show
      render json: domain, status: :ok
    end

    def create
      @domain = Domain.new(params[:domain])
      if @domain.save
        render json: @domain, status: :created
      else
        render json: ::ErrorForm.new(object: @domain).format, status: :bad_request
      end
    end

    def update
      if domain.update(domain_params)
        render json: {}, status: :no_content
      else
        render json: ::ErrorForm.new(object: domain).format, status: :bad_request
      end
    end

    def destroy
      if domain.destroy
        render json: {}, status: :no_content
      else
        render json: ::ErrorForm.new(object: domain).format, status: :bad_request
      end
    end

    private

    def domain
      @domain ||= Domain.find_by(id: params[:id])
    end
    helper_method :domain

    def domain_params
      params.require(:domain).permit(
        :name,
        :account_name,
        :is_canceled,
        :memo,
        :next_updated_at,
        :provider,
        :user_id
      )
    end

    def raise_error_if_not_found
      raise ::NotFoundError unless domain.present?
    end
  end
end
