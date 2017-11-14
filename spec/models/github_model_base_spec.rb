require 'rails_helper'

RSpec.describe GithubModelBase, type: :model do
  context 'When instantiating' do
    it "lets me set my ID" do
      gmb = GithubModelBase.new(id: "12345")
      expect(gmb.id).to eq("12345")
      gmb.id = 12345
      expect(gmb.id).to eq(12345)
    end
    it "should have a ID to be valid" do
      gmb = GithubModelBase.new
      expect(gmb.valid?).to be(false)
      expect(
          gmb.errors.messages[:base].include?("#{gmb.class}'s id must not be nil or blank!")
        ).to be(true)
    end
    it "should not be valid if my ID is not a integer or a string" do
      gmb = GithubModelBase.new(id: false)
      gmb2 = GithubModelBase.new(id: 0.22)
      expect(gmb.valid?).to be(false)
      expect(gmb2.valid?).to be(false)
      expect(
          gmb.errors.messages[:base].include?("#{gmb.class}'s id must be a String, Fixnum got #{gmb.id.class} instead!")
        ).to be(true)
      expect(
          gmb2.errors.messages[:base].include?("#{gmb2.class}'s id must be a String, Fixnum got #{gmb2.id.class} instead!")
        ).to be(true)
    end
    it "should not be valid if it has an adapter_error" do
      adapter_message = "I broke in the GithubAdapter!"
      gmb = GithubModelBase.new(adapter_error: adapter_message)
      expect(gmb.valid?).to be(false)
      expect(
          gmb.errors.messages[:base].include?("GithubAdapter Returned the following message: #{adapter_message} with the following status: ")
        ).to be(true)
    end
  end
  context "With Class Methods" do
    it "Gets an error when querying itself" do
      results = GithubModelBase.query
      expect(results).not_to be_empty
      gmb = results.first
      expect(gmb.adapter_error).not_to be(nil)
      expect(gmb.status).to be(400)
    end
  end
end
