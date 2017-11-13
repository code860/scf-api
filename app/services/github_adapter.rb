require 'octokit'
#BB 11/12/2017 - This is where we will the octokit gem to make the calls to the github api. Using the Client ID and Client Secret in the ENV file we will establish a connection and perform the required requests.  We will utilize this service in our models so they can be serizalized and consumed via the ember project.
class GithubAdapter
  class << self
    def authenticated?
      client.application_authenticated?
    end
    #Hooks for the models
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
      case "#{query_class}"
        when "GithubEvent"
        else
          #Sepcify the error for the tests
          {errors: "You have Specified a non Whitelisted Class to Query!"}
      end
    end
    private
    def client
        Octokit::Client.new(
          client_id: ENV.fetch("GITHUB_CLIENT_ID"),
          client_secret: ENV.fetch("GITHUB_CLIENT_SECRET")
        )
    end
  end
  protected
  # Needed To specify to Octokit which kind of event we want to query
  def query_events(qp = {}, options = {})
    unless query_params.blank? || query_params[:event_type].blank?
      case "#{qp[:event_type]}"
        when "all"
          client.repository_events("#{qp[:username]}/#{qp[:repo]}")
        when "issue_events"
          client.connection.repository_issue_events("#{qp[:username]}/#{qp[:repo]}")
        when "network_events"
          client.connection.repository_network_events("#{qp[:username]}/#{qp[:repo]}")
        else
          #if the event type isnt specified dont return anything
          []
      end
    else
      #Events Types in the query params hash are required so if they hash or the event type are blank return a blank array
      []
    end
  end
end
