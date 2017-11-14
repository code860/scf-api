require 'rails_helper'

RSpec.describe GithubAdapter do
  context "client authentication" do
    describe "with proper environment variables" do
      it "should always be authenticated" do
        expect(GithubAdapter.authenticated?).to be(true)
      end
    end
    describe "with blank environment variables" do
      before(:all) do
        ENV["GITHUB_ACCESS_TOKEN"] = nil
      end
      after(:all) do
        Dotenv.load
      end
      it "should not be authenticated" do
        expect(GithubAdapter.authenticated?).to be(false)
      end
    end
  end
  context "Querying" do
    describe "GithubEvents properly" do
      before(:all) do
        @query_params = {username: "octokit", repo: "octokit.rb"}
        @type = "GithubEvent"
      end
      it "should return an array of results" do
        result = GithubAdapter.query(@type, @query_params)
        expect(result[:json_results]).not_to be_empty
      end
    end
    describe "with any other class" do
      it "should raise an error" do
        t = "FooBar"
        results = GithubAdapter.query(t)
        expect(results[:json_results]).not_to be_empty
        result = results[:json_results].first 
        expect(result).to have_key(:adapter_error)
        expect(result).to have_key(:status)
        expect(result[:status]).to be(400)
        expect(result[:adapter_error]).to eq("#{t} is not specified included in the following whitelist: #{GithubAdapter::QUERY_CLASS_WHITELIST.join(',')}")
      end
    end
  end
end
