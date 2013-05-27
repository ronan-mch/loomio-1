require 'spec_helper'

describe MembershipRequest do
  let(:group) {FactoryGirl.create(:group)}
  let(:membership_request) { MembershipRequest.new(name: 'Bob Dogood',
                                                  email: 'this@that.org.nz',
                                                  group: group) }

  describe 'new' do
    it { should respond_to(:name) }
    it { should respond_to(:email) }
    it { should respond_to(:group) }

    it { should be_valid }

    it "must have a valid email" do
      membership_request.email = '"Joe Gumby" <joe@gumby.com>'
      membership_request.valid?
      membership_request.should have(1).errors_on(:email)
    end

    it "should allow apostrophes in email addresses" do
      membership_request.email = "D'aRCY@kiwi.NZ"
      membership_request.should be_valid
    end


    it "must have only one membership_request for each user email/group pair" do
      # pending
    end
  end
end
