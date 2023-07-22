module Api
  class UsersController < ApplicationController
    def show
      raise ::NotFoundError unless user.present?

      render json: user, status: :ok
    end

    def create
      raise ::InvalidParametersError unless user_params.present?

      @user = ::User.new(user_params)

      if @user.save
        render json: @user, status: :created
      else
        render json: ::ErrorForm.new(object: @user).format, status: :bad_request
      end
    end

    private

    def user
      @user ||= ::User.find_by(id: params[:id])
    end
    helper_method :user

    def user_params
      params.require(:user).permit(
        :name,
        :provider
      )
    end
  end
end
