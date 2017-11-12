require 'octokit'
#BB 11/12/2017 - This is where we will the octokit gem to make the calls to the github api. Using the Client ID and Client Secret in the ENV file we will establish a connection and perform the required requests.  We will utilize this service in our models so they can be serizalized and consumed via the ember project.
class GithubAdapter
  def self.connection(query_params = {})
      Octokit::Client.new(
        client_id: ENV.fetch("GITHUB_CLIENT_ID"),
        client_secret: ENV.fetch("GITHUB_CLIENT_SECRET")
      )
  end
end
