require 'rails_helper'
RSpec.describe ::API::V1::GithubEventsController, type: :controller do
  context "GET index" do
    before(:all) do
      @good_query_params = {username: 'octokit', repo: "octokit.rb"}
      @bad_query_params = {username: "foo", repo: "bar"}
    end
    describe "When using proper query parameters" do
      it "should return a properly formatted json-api response" do
        VCR.use_cassette('good_params_request', record: :new_episodes) do
          get :index, params: @good_query_params
          expect(response).to have_http_status(:ok)
          expect(json_body).to_not be(nil)
          expect(json_body).to have_key("data")
          expect(json_body['data']).to be_a(Array)
          expect(json_body['data']).to_not be_empty, "BB 11/14/2017 If this breaks update the good user/repo params"
          first_obj = json_body['data'].first
          expect(first_obj).to have_key('id')
          expect(first_obj).to have_key('type')
          expect(first_obj).to have_key('attributes')
          expect(first_obj['type']).to eql('github-events')
        end
      end
    end
    describe "When using bad query" do
      it "should return an error with no query params" do
        VCR.use_cassette('no_params_request', record: :new_episodes) do
          get :index, params: {}
          expect(response).to have_http_status(400)
          expect(json_body).to have_key('meta')
          expect(json_body).to have_key('data')
          expect(json_body['data']).to be_empty
          expect(json_body['meta']).to have_key('error-msg')
          expect(json_body['meta']['error-msg']).to_not be(nil)
          expect(json_body['meta']['error-msg']).to be_a(String)
        end
      end
      it "should return a message with no reults" do
        VCR.use_cassette('bad_params_request', record: :new_episodes) do
          get :index, params: @bad_query_params
          expect(response).to have_http_status(404)
          expect(json_body).to have_key('meta')
          expect(json_body).to have_key('data')
          expect(json_body['data']).to be_empty
          expect(json_body['meta']).to have_key('error-msg')
          expect(json_body['meta']['error-msg']).to_not be(nil)
          expect(json_body['meta']['error-msg']).to be_a(String)
        end
      end
    end
  end
end
