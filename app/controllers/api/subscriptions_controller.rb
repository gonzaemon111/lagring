module Api
  class SubscriptionsController < ::Api::ApplicationController
    before_action :raise_error_if_not_found, only: %i[show update destroy]

    def index
      @subscriptions = current_user.subscriptions.order(:updated_at)
    end

    def show; end

    def create
      raise ::InvalidParametersError unless params[:subscription].present?

      @subscription = current_user.subscriptions.new(subscription_params)

      if @subscription.save
        render :create, format: :json, status: :created
      else
        render json: ::ErrorForm.new(object: @subscription).format, status: :bad_request
      end
    end

    def update
      raise ::InvalidParametersError unless params[:subscription].present?

      if subscription.update(subscription_params)
        render :show, format: :json, status: :ok
      else
        render json: ::ErrorForm.new(object: subscription).format, status: :bad_request
      end
    end

    def destroy
      if subscription.destroy
        render :show, format: :json, status: :ok
      else
        render json: ::ErrorForm.new(object: subscription).format, status: :bad_request
      end
    end

    private

    def subscription
      @subscription ||= current_user.subscriptions.find_by(id: params[:id])
    end
    helper_method :subscription

    def subscription_params
      params.require(:subscription).permit(
        :name,
        :started_at,
        :finished_at,
        :price,
        :image_url,
        :repeat_frequency,
        :memo
      )
    end

    def raise_error_if_not_found
      raise ::NotFoundError unless subscription.present?
    end
  end
end
