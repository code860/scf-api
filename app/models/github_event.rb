class GithubEvent < GithubModelBase
  attr_accessor :github_user_id, :github_repo_id, :type, :created_at, :public
  belongs_to :github_user
  belongs_to :github_repo

  alias_method :event_type, :type
  alias_method :public_event, :public#To avoid collisions on the ember side

  def initialize(attrs = {})
    super(attrs)
    # self.github_user = parse_user(attrs)
    # self.github_repo = parse_repo(attrs)
  end

  #TODO figure out how to  serialize these in json api format
  # private
  # def parse_user(attrs = {})
  #   user = GithubUser.new(attrs.try(:[], :actor))
  #   user.valid? ? user : nil
  # end
  # def parse_repo(attrs = {})
  #   repo = GithubRepo.new(attrs.try(:[], :repo))
  #   repo.valid? ? repo : nil
  # end
end
