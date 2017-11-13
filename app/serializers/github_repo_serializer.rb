class GithubRepoSerializer < GithubModelBaseSerializer
  attributes :name, :description, :private, :html_url
end
