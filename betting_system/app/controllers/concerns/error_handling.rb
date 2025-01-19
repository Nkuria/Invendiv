# require_relative '../../../app/errors/unauthorized_error'
module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from UnauthorizedError, with: :render_unauthorized
    rescue_from CustomError, with: :render_custom_error
    rescue_from ApplicationError, with: :render_application_error
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActionController::RoutingError, with: :render_not_found
    rescue_from StandardError do |exception|
      render json: { status: 500, error: "Internal Server Error: #{exception.message}" }, status: :internal_server_error
    end
  end

  private

  def render_not_found(exception)
    render json: { status: 404, error: exception.message }, status: :not_found
  end

  def render_unprocessable_entity(exception)
    render json: { status: 422, error: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def render_unauthorized(exception)
    render json: { error: exception.message }, status: :unauthorized
  end

  def render_custom_error(exception)
    render json: { error: exception.message, details: exception.details }, status: exception.status
  end

  def render_application_error(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end
