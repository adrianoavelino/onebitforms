module Api::V1

 class ApiController < ApplicationController
   rescue_from(ActiveRecord::RecordNotFound) do ||
      render(json: {message: 'Not Found'}, status: :not_found)
   end
 end

end
