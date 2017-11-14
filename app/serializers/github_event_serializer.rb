class GithubEventSerializer < GithubModelBaseSerializer
  attributes :event_type, :created_at, :public_event, :user_name, :user_avatar, :repo_name
  # has_one :github_user
  # has_one :github_repo
end
