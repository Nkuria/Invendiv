module Api
  module V1
    class BetsController < ApplicationController
      before_action :authenticate_user
      before_action :set_user

      def index
        @bets = current_user.bets
        render json: @bets
      end

      def show
        render json: Bet.find(params[:id])
      end

      def create
        @bet = Bet.new(bet_params)
        @bet.user = current_user

        if @bet.save
          render json: @bet, status: :created
        else
          render json: @bet.errors, status: :unprocessable_entity
        end
      end

      private

      def set_user
        @user = User.find(params[:user_id])
      end

      def bet_params
        params.require(:bet).permit(:game_id, :odd_id, :stake)
      end
    end
  end
end
