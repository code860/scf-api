class API::V1::GithubEventsController < API::V1::APIController
  before_action :check_query_params, only: [:index]
  def index
  end

  def show
  end

  private
  def check_query_params
    [:username, :repo].each do |required_param|
      if params[required_param].blank?
        render json: {status: 400, message: "Error missing #{required_param} parameter"}
      end
    end
  end
end
