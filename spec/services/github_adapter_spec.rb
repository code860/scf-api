require 'rails_helper'

RSpec.describe GithubAdapter do
  context "client" do
    it "should always be authenticated" do
      adapter_authenticated = GithubAdapter.authenticated?
      expect(adapter_authenticated).to be(true)
    end
  end
end
