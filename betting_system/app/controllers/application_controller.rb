class ApplicationController < ActionController::API
  include ErrorHandling
  include Authenticable

  def authenticate_user
    # return unless current_user.nil?

    raise UnauthorizedError, 'You must be logged in'
  end
end
