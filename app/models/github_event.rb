class GithubEvent < GithubModelBase
  attr_accessor  :type, :created_at, :public, :name, :display_login, :avatar_url
  # belongs_to :github_user
  # belongs_to :github_repo
  #TODO figure out how to make relationships without ActiveRecord more friendly to serializer. Look into ActiveResource::Model or perhaps even having a NOSQL solution like Mogo
  alias_method :event_type, :type
  alias_method :public_event, :public #To avoid collisions on the ember side
  alias_method :repo_name, :name
  alias_method :user_name, :display_login
  alias_method :user_avatar, :avatar_url

  def initialize(attrs = {})
    super(attrs)
    [:actor, :repo].each do |nested_key|
      parse_nested(attrs.try(:[], nested_key).blank? ? {} : attrs[nested_key])
    end
    # self.github_user = parse_user(attrs)
    # self.github_repo = parse_repo(attrs)
  end


  private

  #Since relationships dont work I adding a parse nested attributes function
  def parse_nested(nested_attrs = {})
    nested_attrs.each do |name, value|
      attr_name = name.to_s.underscore
      unless attr_name == "id"
        send("#{attr_name}=", value) if respond_to?("#{attr_name}=")
      end
    end
  end
  # def parse_user(attrs = {})
  #   user = GithubUser.new(attrs.try(:[], :actor))
  #   user.valid? ? user : nil
  # end
  # def parse_repo(attrs = {})
  #   repo = GithubRepo.new(attrs.try(:[], :repo))
  #   repo.valid? ? repo : nil
  # end
end
