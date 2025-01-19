require 'test_helper'

class BetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other_user = users(:two)
    @game = games(:one)
    @odd = odds(:one)
    @bet = bets(:one)
    @auth_headers = { Authorization: JsonWebToken.encode(user_id: @user.id) }
  end

  test 'should get all bets for current user' do
    get "/api/v1/users/#{@user.id}/bets", headers: @auth_headers
    assert_response :success

    response_data = JSON.parse(response.body)
    assert_equal @user.bets.count, response_data.size
  end

  test 'should show a single bet' do
    get "/api/v1/bets/#{@bet.id}", headers: @auth_headers
    assert_response :success

    response_data = JSON.parse(response.body)
    assert_equal @bet.id, response_data['id']
  end

  test 'should create a new bet' do
    bet_params = { bet: { game_id: @game.id, odd_id: @odd.id, stake: 100 } }

    assert_difference '@user.bets.count', 1 do
      post '/api/v1/bets', params: bet_params, headers: @auth_headers
    end

    assert_response :created
    response_data = JSON.parse(response.body)
    assert_equal '100.0', response_data['stake']
    assert_equal 'pending_outcome', response_data['outcome']
  end

  test 'should not create a bet with invalid params' do
    invalid_params = { bet: { game_id: nil, odd_id: nil, stake: nil } }

    assert_no_difference '@user.bets.count' do
      post '/api/v1/bets', params: invalid_params, headers: @auth_headers
    end

    assert_response :unprocessable_entity
  end

  test 'should not allow unauthorized access' do
    get "/api/v1/users/#{@user.id}/bets"
    assert_response :unauthorized

    post '/api/v1/bets', params: { bet: { game_id: @game.id, odd_id: @odd.id, stake: 100 } }
    assert_response :unauthorized

    get "/api/v1/bets/#{@bet.id}"
    assert_response :unauthorized
  end
end
