module Api
  class UsersController < ::Api::ApplicationController
    def show
      raise ::NotFoundError unless user.present?

      render json: user, status: :ok
    end

    # NOTE: ある場合はfindし,ユーザーがない場合は作成する
    def create
      raise ::InvalidParametersError unless user_params.present?

      find_user = ::User.find_by(email: user_params[:email], provider: user_params[:provider])
      return render json: { token: ::Users::GenerateTokenOperator.process(user: find_user) }, status: :ok if find_user.present?

      @user = ::User.new(user_params)

      if @user.save
        render json: { token: ::Users::GenerateTokenOperator.process(user: @user) }, status: :ok
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
        :provider,
        :email,
        :picture
      )
    end
  end
end
