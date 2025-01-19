class CustomError < StandardError
  attr_reader :status, :details

  def initialize(message = 'Something went wrong', status = :bad_request, details = {})
    super(message)
    @status = status
    @details = details
  end
end