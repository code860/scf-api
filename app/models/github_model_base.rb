class GithubModelBase
  #BB 11/12/2017 Need These to make the model feel like active record
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  include ActiveModel::Associations
  include ActiveModel::Serialization

  attr_accessor :id, :adapter_error, :status

  validate :valid_id
  validate :no_adapter_errors

  def initialize(args = {})
     args.each do |name, value|
       attr_name = name.to_s.underscore
       send("#{attr_name}=", value) if respond_to?("#{attr_name}=")
     end
   end

  ##################
  # Class Methods  #
  ##################
  #Hook into Github Adapater
  class << self
    def type
      self.to_s
    end

    def query(query_params = {}, options ={})
      result = GithubAdapter.query(type, query_params, options)
      result[:json_results].map{|json_attrs| type.constantize.new(json_attrs)}
    end

    def find(id)
      GithubAdapter.find(id, type)
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

  protected
  #Validations
  def valid_id
    self.errors.add(:base, "#{self.class}'s id must not be nil or blank!") unless self.id.present?
    self.errors.add(:base,
      "#{self.class}'s id must be a String, Fixnum got #{self.id.class} instead!"
      ) unless [String, Fixnum].include? self.id.class
  end

  def no_adapter_errors
    self.errors.add(:base,
      "GithubAdapter Returned the following message: #{self.adapter_error} with the following status: #{self.status}"
      ) unless self.adapter_error.blank?
  end
end
