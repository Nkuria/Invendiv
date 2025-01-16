class Api::V1::BetsController < ApplicationController
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

  def bet_params
    params.require(:bet).permit(:game_id, :odd_id, :stake)
  end
end
