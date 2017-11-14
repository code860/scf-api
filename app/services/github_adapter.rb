require 'octokit'
#BB 11/12/2017 - This is where we will the octokit gem to make the calls to the github api. Using the GITHUB_ACCESS_TOKEN in the ENV file we will establish a connection and perform the required requests.  We will utilize this service in our models so they can be serizalized and consumed via the ember project.

class GithubAdapter
  #Added a whitelisting system to only allow certain models to use the query and the find methods
  FIND_CLASS_WHITELIST = %w(GithubUser GithubRepo GithubEvent)
  QUERY_CLASS_WHITELIST = %w(GithubEvent)
  class << self
    #This is for the tests
    def authenticated?
      github_client.token_authenticated?
    end
    #Public Hooks for the  parent GITHUB model
    def find(id, type =  nil)
      result = {json_result: nil}
      begin
        check_client_authentication# These need to be more DRY
        ensure_type(type, FIND_CLASS_WHITELIST)
        case
          when "GithubUser"
          when "GithubRepo"
          when "GithubEvent"
        end
      rescue GithubAdapterError => e
        result[:json_result] = e.return_hash
      end
      return result
    end

    def query(type= nil, query_params = {}, query_options = {})
      result = {json_results: [], status: 200}
      begin
        check_client_authentication# These need to be more DRY
        ensure_type(type, QUERY_CLASS_WHITELIST)
        case "#{type}"
          when "GithubEvent"
            result[:json_results] = github_client.repository_events("#{query_params[:username]}/#{query_params[:repo]}")
        end
      rescue Octokit::NotFound => e
        Rails.logger.info "====================="
        Rails.logger.info e.to_s
        Rails.logger.info "====================="
        result.merge!({adapter_error: "No results found", status: 404})
      rescue Octokit::Forbidden => e
        Rails.logger.info "====================="
        Rails.logger.info e.to_s
        Rails.logger.info "====================="
        result.merge!({
            adapter_error: "You are not allowed to view this repositories events please try another one",
            status: 403
          })
      rescue GithubAdapterError => e
        result.merge!(e.return_hash)
      end
      return result
    end

    private
    #Client Should only be accessible in the adapter to make hooks for the models
    def github_client
        Octokit::Client.new(
          access_token: ENV.try(:[], "GITHUB_ACCESS_TOKEN"),
          auto_paginate: true
        )
    end
    #Adapter Validations
    #TODO- Ideally these should be wrapped into a custom callback module for this class to make it more DRY however due to the timeline I will have to come back later to implemet something like that
    def check_client_authentication
      raise GithubAdapterError.new(
        "Error Invalid Client Credentials!", 401
        ) unless authenticated?
    end

    def ensure_type(type, whitelist)
      raise GithubAdapterError.new(
        "Class Type specified is nil or blank!"
        ) unless type.present?
      raise GithubAdapterError.new(
          "#{type} is not specified included in the following whitelist: #{whitelist.join(',')}"
          ) unless whitelist.include? type
    end
  end
end

class GithubAdapterError < StandardError
  attr_reader :adapter_error, :status
  def initialize(adapter_error="Something Went Wrong", status=400, msg="GithubAdapter Error!")
    @adapter_error = adapter_error
    @status = status
    super(msg)
  end

  def return_hash
    {adapter_error: self.adapter_error, status: self.status}
  end
end
