class GithubEventSerializer < GithubModelBaseSerializer
  attributes :event, :created_at, :commit_id, :commit_url
  belongs_to :github_user
  belongs_to :github_repo
end
