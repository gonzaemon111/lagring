module Api
  class ShoppingsController < ::Api::ApplicationController
    before_action :raise_error_if_not_found, only: %i[show update destroy]

    def index
      @shoppings = current_user.shoppings.order(:updated_at)
    end

    def show; end

    def create
      raise ::InvalidParametersError unless params[:shopping].present?

      @shopping = current_user.shoppings.new(shopping_params)

      if @shopping.save
        render :create, format: :json, status: :created
      else
        render json: ::ErrorForm.new(object: @shopping).format, status: :bad_request
      end
    end

    def update
      raise ::InvalidParametersError unless params[:shopping].present?

      if shopping.update(shopping_params)
        render :show, format: :json, status: :ok
      else
        render json: ::ErrorForm.new(object: shopping).format, status: :bad_request
      end
    end

    def destroy
      if shopping.destroy
        render :show, format: :json, status: :ok
      else
        render json: ::ErrorForm.new(object: shopping).format, status: :bad_request
      end
    end

    private

    def shopping
      @shopping ||= current_user.shoppings.find_by(id: params[:id])
    end
    helper_method :shopping

    def shopping_params
      params.require(:shopping).permit(
        :name,
        :is_bought,
        :image_url,
        :url,
        :price,
        :shop,
        :memo
      )
    end

    def raise_error_if_not_found
      raise ::NotFoundError unless shopping.present?
    end
  end
end
