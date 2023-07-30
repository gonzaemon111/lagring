module Api
  class ChecklistsController < ::Api::ApplicationController
    before_action :raise_error_if_not_found, only: %i[show update destroy]

    def index
      @checklists = current_user.checklists.order(:updated_at)
    end

    def show; end

    def create
      raise ::InvalidParametersError unless params[:checklist].present?

      @checklist = current_user.checklists.new(checklist_params)

      if @checklist.save
        render :create, format: :json, status: :created
      else
        render json: ::ErrorForm.new(object: @checklist).format, status: :bad_request
      end
    end

    def update
      raise ::InvalidParametersError unless params[:checklist].present?

      if checklist.update(checklist_params)
        render :show, format: :json, status: :ok
      else
        render json: ::ErrorForm.new(object: checklist).format, status: :bad_request
      end
    end

    def destroy
      if checklist.destroy
        render :show, format: :json, status: :ok
      else
        render json: ::ErrorForm.new(object: checklist).format, status: :bad_request
      end
    end

    private

    def checklist
      @checklist ||= current_user.checklists.find_by(id: params[:id])
    end
    helper_method :checklist

    def checklist_params
      params.require(:checklist).permit(
        :name,
        :date,
        :repeat_frequency,
        :memo
      )
    end

    def raise_error_if_not_found
      raise ::NotFoundError unless checklist.present?
    end
  end
end
