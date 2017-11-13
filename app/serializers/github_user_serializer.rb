class GithubUserSerializer < ActiveModel::Serializer
  attributes :username, :avatar_url, :html_url
end
