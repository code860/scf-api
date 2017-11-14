class GithubModelBase
  #BB 11/12/2017 Need These to make the model feel like active record
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  # include ActiveModel::Associations this doesn't work unless you have relatioship backed by ActiveRecord
  include ActiveModel::Serialization

  attr_accessor :id, :error_msg, :status

  validate :valid_id

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
      parse_query_results(GithubAdapter.query(type, query_params, options))
    end

    def find(id)
      #Currently not fully implemented
      GithubAdapter.find(id, type)
    end

    private
    def parse_query_results(results)
      parsed_results = {objects: [], meta: {}, status: 200}
      if results[:adapter_error].present?
        parsed_results[:meta] = {error_msg: results[:adapter_error]}
        parsed_results[:status] = results[:status]
      else
        parsed_results[:objects] = results[:json_results].map{|json_attr| type.constantize.new(json_attr)}
      end
      parsed_results
    end
  end

  ##################
  #Instance Methods#
  ##################

  # BB 11/12/2017 Need These getters/ setters for relationships
  # BB 11/14/2017 Don't Need these now because of the way ActiveModel::Associations expects at least one ActiveRecord Relationship
  # def [](attr)
  #   self.send(attr)
  # end
  #
  # def []=(attr, value)
  #   self.send("#{attr}=", value)
  # end

  protected
  #Validations
  def valid_id
    self.errors.add(:base, "#{self.class}'s id must not be nil or blank!") unless self.id.present?
    self.errors.add(:base,
      "#{self.class}'s id must be a String, Fixnum got #{self.id.class} instead!"
      ) unless [String, Fixnum].include? self.id.class
  end
end
