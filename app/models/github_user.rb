class GithubUser < GithubModelBase
  attr_accessor :login, :avatar_url, :html_url, :username
  alias_method :login, :username
end
