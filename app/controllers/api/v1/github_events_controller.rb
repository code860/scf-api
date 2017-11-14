class API::V1::GithubEventsController < API::V1::APIController
  before_action :check_query_params, only: [:index]
  def index
    render json: GithubEvent.query(params), status: 200
  end

  def show
  end

  private
  def check_query_params
    [:username, :repo].each do |required_param|
      if params[required_param].blank?
        render json: {status: 400, message: "Error missing #{required_param} parameter"} and return
      end
    end
  end
end
