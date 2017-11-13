require 'rails_helper'

RSpec.describe GithubModelBase, type: :model do
  context 'instantiate' do
    it "Only lets me set my id and errors if I have any" do
      gmb = GithubModelBase.new(id: "12345", errors: "I have some Errors!")
      expect(gmb.id).to eq("12345")
      expect(gmb.errors).to eq("I have some Errors!")
    end
  end
end
