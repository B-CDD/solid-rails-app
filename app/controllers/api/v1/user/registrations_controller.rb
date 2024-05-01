# frozen_string_literal: true

module API::V1
  class User::RegistrationsController < BaseController
    skip_before_action :authenticate_user!, only: [:create]

    def create
      user = ::User.new(user_params)

      if user.save
        render_json_with_success(status: :created, data: {access_token: user.token.access_token})
      else
        render_json_with_model_errors(user)
      end
    end

    def destroy
      current_user.destroy!

      render_json_with_success(status: :ok)
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end
