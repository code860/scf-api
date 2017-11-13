class GithubUser < GithubModelBase
  attr_accessor :login, :avatar_url, :html_url, :username
  alias :login, :username
end
