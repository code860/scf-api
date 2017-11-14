class API::V1::GithubEventsController < API::V1::APIController
  before_action :check_query_params, only: [:index]
  def index
    results = GithubEvent.query(params)
    render json: results[:objects], meta: results[:meta], status: results[:status]
  end

  def show
    #TODO
  end

  private
  def check_query_params
    [:username, :repo].each do |required_param|
      if params[required_param].blank?
        render json: [], status: 400, meta: {error_msg: "Error missing #{required_param} parameter"} and return
      end
    end
  end
end
