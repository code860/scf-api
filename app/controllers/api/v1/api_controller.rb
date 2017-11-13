class API::V1::APIController < ApplicationController
   #BB 11/12/2017 This is where we would do api authentication wth JWT if we had a login with this application
   private
   def query_params
     params.permit(:event_type, :username, :repo)
   end
end
