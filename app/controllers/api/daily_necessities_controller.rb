module Api
  class DailyNecessitiesController < ::Api::ApplicationController
    before_action :raise_error_if_not_found, only: %i[show update destroy]

    def index
      @daily_necessities = current_user.daily_necessities.order(:updated_at)
      render json: { daily_necessities: @daily_necessities }, status: :ok
    end

    def show
      render json: daily_necessity, status: :ok
    end

    def create
      raise ::InvalidParametersError unless params[:daily_necessity].present?

      @daily_necessity = current_user.daily_necessities.new(daily_necessity_params)

      if @daily_necessity.save
        render json: @daily_necessity, status: :created
      else
        render json: ::ErrorForm.new(object: @daily_necessity).format, status: :bad_request
      end
    end

    def update
      raise ::InvalidParametersError unless params[:daily_necessity].present?

      if daily_necessity.update(daily_necessity_params)
        render json: daily_necessity, status: :ok
      else
        render json: ::ErrorForm.new(object: daily_necessity).format, status: :bad_request
      end
    end

    def destroy
      if daily_necessity.destroy
        render json: daily_necessity, status: :ok
      else
        render json: ::ErrorForm.new(object: daily_necessity).format, status: :bad_request
      end
    end

    private

    def daily_necessity
      @daily_necessity ||= current_user.daily_necessities.find_by(id: params[:id])
    end
    helper_method :daily_necessity

    def daily_necessity_params
      params.require(:daily_necessity).permit(
        :name,
        :quantity,
        :image_url,
        :memo
      )
    end

    def raise_error_if_not_found
      raise ::NotFoundError unless daily_necessity.present?
    end
  end
end
