module Authenticable
  def current_user
    return @current_user if @current_user

    header = request.headers['Authorization']
    return nil if header.nil?

    decoded = JsonWebToken.decode(header.split(' ').last)
    @current_user = begin
                      User.find(decoded[:user_id])
    rescue StandardError
                      ActiveRecord::RecordNotFound
    end
  end
end
