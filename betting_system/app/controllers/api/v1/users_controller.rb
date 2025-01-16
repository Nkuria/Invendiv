module Api
  module V1
    class UsersController < ApplicationController
      def show
        render json: User.find(params[:id])
      end

      def create
        @user = User.new(user_params)
        @user.verified = false

        if @user.save
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :first_name, :surname)
      end
    end
  end
end
