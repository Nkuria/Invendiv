require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test 'should show a user' do
    get "/api/v1/users/#{@user.id}"
    assert_response :success

    response_data = JSON.parse(response.body)
    assert_equal @user.id, response_data['id']
    assert_equal @user.email, response_data['email']
  end

  test 'should create a new user with valid parameters' do
    user_params = {
      user: {
        email: 'newuser@example.com',
        password: 'password123',
        first_name: 'New',
        surname: 'User'
      }
    }

    assert_difference 'User.count', 1 do
      post '/api/v1/users', params: user_params
    end

    assert_response :created

    response_data = JSON.parse(response.body)
    assert_equal 'newuser@example.com', response_data['email']
    assert_equal 'New', response_data['first_name']
    assert_equal 'User', response_data['surname']
    assert_not response_data['verified'] # Ensure verified is false
  end

  test 'should not create a user with invalid parameters' do
    invalid_params = {
      user: {
        email: nil,
        password: nil,
        first_name: nil,
        surname: nil
      }
    }

    assert_no_difference 'User.count' do
      post '/api/v1/users', params: invalid_params
    end

    assert_response :unprocessable_entity

    response_data = JSON.parse(response.body)
    assert_includes response_data['email'], "can't be blank"
    assert_includes response_data['password'], "can't be blank"
    assert_includes response_data['first_name'], "can't be blank"
    assert_includes response_data['surname'], "can't be blank"
  end
end
