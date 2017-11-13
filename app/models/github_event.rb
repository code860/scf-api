class GithubEvent < GithubModelBase
  attr_accessor :github_user_id, :github_repo_id, :event, :created_at, :commit_id, :commit_url
  belongs_to :github_user
  belongs_to :github_repo

  def initialize(args = {})
    super(args)
  end
end
