require 'rails_helper'

RSpec.describe GithubEvent, type: :model do
  context 'When instantiating' do
    it "sets attributes and use aliased ones" do
      t = DateTime.now
      ge = GithubEvent.new(id: "12345", public: true, type: "SomeEventType", created_at: t)
      expect(ge.id).to eq("12345")
      expect(ge.public_event).to be(true)
      expect(ge.public).to be(true)
      expect(ge.type).to eql("SomeEventType")
      expect(ge.event_type).to eq("SomeEventType")
      expect(ge.created_at).to eq(t)
    end
    it "should not let me set other attributes" do
      ge = GithubEvent.new(foo: "bar")
      expect(ge.valid?).to be(false)
      expect{ge.foo}.to raise_error(NoMethodError)
    end
    it "can belong_to a GithubRepo" do
      skip "Relatiosnhips Dont Work between non DB backed examples for a JSONAPI formatted seriaizer"
      t = DateTime.now
      gr = GithubRepo.new(id: "4567", name: "Test")
      ge = GithubEvent.new(id: "12345", public: true, type: "SomeEventType", created_at: t)
      ge.github_repo_id = gr.id
      expects(ge.github_repo).to_not be(nil), "apparently This Thinks im using ActiveRecord... Somehow...."
    end
    describe "Should have the same validations as parent" do
      it "should have a ID to be valid" do
        ge = GithubEvent.new
        expect(ge.valid?).to be(false)
        expect(
            ge.errors.messages[:base].include?("#{ge.class}'s id must not be nil or blank!")
          ).to be(true)
      end
      it "should not be valid if my ID is not a integer or a string" do
        ge = GithubEvent.new(id: false)
        ge2 = GithubEvent.new(id: 0.22)
        expect(ge.valid?).to be(false)
        expect(ge2.valid?).to be(false)
        expect(
            ge.errors.messages[:base].include?("#{ge.class}'s id must be a String, Fixnum got #{ge.id.class} instead!")
          ).to be(true)
        expect(
            ge2.errors.messages[:base].include?("#{ge2.class}'s id must be a String, Fixnum got #{ge2.id.class} instead!")
          ).to be(true)
      end
    end
  end
end
