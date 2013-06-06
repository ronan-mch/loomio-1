require 'spec_helper'

describe MembershipRequest do
  let(:group) { stub_model Group }
  let(:membership_request) do
    m = MembershipRequest.new(name: 'Bob Dogood', email: 'this@that.org.nz')
    m.group = group
    m
  end

  describe '#new' do

    subject { membership_request }

    it { should respond_to(:name) }
    it { should respond_to(:email) }
    it { should respond_to(:group) }

    it { should be_valid }

    it "must have a valid email" do
      membership_request.email = '"Joe Gumby" <joe@gumby.com>'
      membership_request.valid?
      membership_request.should have(1).errors_on(:email)
    end

    it "allows apostrophes in email addresses" do
      membership_request.email = "D'aRCY@kiwi.NZ"
      membership_request.valid?
      membership_request.should have(0).errors_on(:email)
    end
  end

  describe 'validations' do
    context 'there is a group member with same email' do
      it 'adds error on :email' do
        membership_request.stub_chain(:group_members, :find_by_email).and_return(true)
        membership_request.stub_chain(:group_membership_requests, :find_by_email).and_return(false)
        membership_request.save
        membership_request.errors_on(:email).join.should =~ /this address belongs to someone already in this group/i
      end
    end

    context 'there is a membership request already with the same email' do
      it 'adds error on :email' do
        membership_request.stub_chain(:group_members, :find_by_email).and_return(false)
        membership_request.stub_chain(:group_membership_requests, :find_by_email).and_return(true)
        membership_request.save
        membership_request.errors_on(:email).join.should =~ /you have already requested membership/i
      end
    end
  end

  describe '#approve!' do
    it "changes the :status attribute to approved"
    it "records who responded"
    it "records the response"

    context "membership request from signed-out user" do
      it "creates an invitation to join the group"
      it "delivers an invitation"
    end

    context "membership request from signed-in user" do
      it "creates a membership for the user in the group"
    end
  end
end
