require 'octokit'
#BB 11/12/2017 - This is where we will the octokit gem to make the calls to the github api. Using the Client ID and Client Secret in the ENV file we will establish a connection and perform the required requests.  We will utilize this service in our models so they can be serizalized and consumed via the ember project.
class GithubAdapter
  class << self
    #This is for the tests
    def authenticated?
      client.application_authenticated?
    end
    #Public Hooks for the models
    def find(type, id)
      case
        when "GithubUser"
        when "GithubRepo"
        else
          #Sepcify the error for the tests
          {errors: "You cannot Specify a non Whitelisted Class to the find method!"}
      end
    end
    def query(type, query_params = {}, options = {})
      case "#{type}"
        when "GithubEvent"
          results = client.repository_events("#{query_params[:username]}/#{query_params[:repo]}")
        else
          [{errors: "You have Specified a non Whitelisted Class to Query!"}]
      end
    end

    private #Client Should only be accessible in the adapter to make hooks for the models
    def client
        Octokit::Client.new(
          client_id: ENV.fetch("GITHUB_CLIENT_ID"),
          client_secret: ENV.fetch("GITHUB_CLIENT_SECRET")
        )
    end
  end
end
