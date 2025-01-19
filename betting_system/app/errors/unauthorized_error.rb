class UnauthorizedError < ApplicationError
   Rails.logger.error 'Raising UnauthorizedError'
end
