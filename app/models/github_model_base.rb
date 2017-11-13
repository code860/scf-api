class GithubModelBase
  #BB 11/12/2017 Need These to make the model feel like active record
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  include ActiveModel::Associations

  attr_accessor :id, :errors


  def initialize(args = {})
     args.each do |name, value|
       attr_name = name.to_s.underscore
       send("#{attr_name}=", value) if respond_to?("#{attr_name}=")
     end
   end

  ##################
  # Class Methods  #
  ##################
  class << self
    def type
      self.to_s
    end

    def query(query_params = {}, options ={})
      GithubAdapter.query(type, query_params, options)
    end

    def find(id)
      GithubAdapter.find(type, self.id)
    end
  end

  ##################
  #Instance Methods#
  ##################


  # BB 11.12/2017 Need These getters/ setters for relationships
  def [](attr)
    self.send(attr)
  end

  def []=(attr, value)
    self.send("#{attr}=", value)
  end
end
