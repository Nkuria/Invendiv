class ApplicationController < ActionController::API
  include Authenticable
  include ErrorHandling

  def authenticate_user
    return unless current_user.nil?

      render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
