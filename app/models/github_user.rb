class GithubUser < GithubModelBase
  attr_accessor :display_login, :avatar_url
  alias_method :username, :display_login
end
