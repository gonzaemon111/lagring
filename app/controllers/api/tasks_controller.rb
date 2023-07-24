module Api
  class TasksController < ::Api::ApplicationController
    before_action :raise_error_if_not_found, only: %i[show update destroy]

    def index
      @tasks = current_user.tasks.order(:updated_at)
      render json: { tasks: @tasks }, status: :ok
    end

    def show
      render json: task, status: :ok
    end

    def create
      raise ::InvalidParametersError unless params[:task].present?

      @task = current_user.tasks.new(task_params)

      if @task.save
        render json: @task, status: :created
      else
        render json: ::ErrorForm.new(object: @task).format, status: :bad_request
      end
    end

    def update
      raise ::InvalidParametersError unless params[:task].present?

      if task.update(task_params)
        render json: task, status: :ok
      else
        render json: ::ErrorForm.new(object: task).format, status: :bad_request
      end
    end

    def destroy
      if task.destroy
        render json: task, status: :ok
      else
        render json: ::ErrorForm.new(object: task).format, status: :bad_request
      end
    end

    private

    def task
      @task ||= current_user.tasks.find_by(id: params[:id])
    end
    helper_method :task

    def task_params
      params.require(:task).permit(
        :name,
        :deadline,
        :finished_at,
        :memo,
        :category_name
      )
    end

    def raise_error_if_not_found
      raise ::NotFoundError unless task.present?
    end
  end
end
