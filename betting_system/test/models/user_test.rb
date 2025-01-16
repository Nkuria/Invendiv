require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should be valid with valid attributes' do
    user = User.new(first_name: 'John', surname: 'Doe', email: Faker::Internet.unique.email, password: 'password123',
                    verified: true)
    assert user.valid?
  end

  # Test if user is invalid without a password
  test 'should be invalid without password' do
    user = User.new(first_name: 'John', surname: 'Doe', email: Faker::Internet.email, verified: true)
    assert_not user.valid?
  end

  # Test associations
  test 'should have many bets' do
    user = users(:one) # Assuming you have a fixture for users
    assert_respond_to user, :bets
  end
end
