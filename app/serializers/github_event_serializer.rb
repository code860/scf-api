class GithubEventSerializer < GithubModelBaseSerializer
  attributes :event_type, :created_at, :public_event
  # has_one :github_user
  # has_one :github_repo
end
