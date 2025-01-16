require 'test_helper'

class Api::V1::BetsControllerTest < ActionDispatch::IntegrationTest
  def authenticate_user
    @user = users(:one)
    @token = JsonWebToken.encode(user_id: @user.id)
    @invalid_token = JsonWebToken.encode(user_id: 'atds')
  end

  setup do
    authenticate_user
    @game = games(:one)
    @odd = odds(:one)
    @bet_params = { game_id: @game.id, odd_id: @odd.id, stake: 100 }
  end

  test 'should get index' do
    @bet = Bet.create!(game_id: @game.id, odd_id: @odd.id, stake: 50, user: @user)

    get "/api/v1/users/#{@user.id}/bets", headers: { Authorization: "Bearer #{@token}" }

    assert_response :success
    assert_includes response.body, @bet.id.to_s
  end

  test 'should create bet' do
    assert_difference('Bet.count') do
      post api_v1_bets_url, params: { bet: @bet_params }, headers: { Authorization: "Bearer #{@token}" }
    end

    assert_response :created
    bet = Bet.last
    assert_equal @user.id, bet.user_id
    assert_equal @bet_params[:stake], bet.stake
  end

  test 'should not create bet with invalid parameters' do
    invalid_params = { game_id: nil, odd_id: nil, stake: nil }

    post api_v1_bets_url, params: { bet: invalid_params }, headers: { Authorization: "Bearer #{@token}" }

    assert_response :unprocessable_entity
  end

  test 'should return 401 for unauthorized access' do
    post api_v1_bets_url, params: { bet: @bet_params }

    assert_response :unauthorized
    assert_includes response.body, 'Unauthorized'
  end
end
