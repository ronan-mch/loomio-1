require 'spec_helper'

describe Groups::ManageMembershipRequestsController do
  describe "#index"

  describe "#approve" do
    let(:group) { mock_model Group }
    let(:membership_request) { mock_model MembershipRequest, group: group, name: "James Roland", response: nil }
    let(:coordinator) { create(:user) }
    let(:requestor) { mock_model User }

    before do
      controller.stub(:set_locale)
      controller.stub(:load_announcements)
      controller.stub(:current_user).and_return coordinator
      MembershipRequest.stub(:find).and_return(membership_request)
      Group.stub(:find).with(group.id.to_s).and_return(group)
      ManageMembershipRequests.stub(:approve!)
      sign_in coordinator
    end

    context "user doesn't have permission to approve membership request" do
      it 'redirects to group with flash error' do
        post :approve, id: membership_request.id
        response.should redirect_to group_path(group)
        flash[:warning].should == I18n.t("warning.user_not_admin", which_user: coordinator.name)
      end
      it 'does not approve the membership request' do
        membership_request.should_not_receive(:approve!)
        post :approve, id: membership_request.id
      end
    end

    context "user has permission to approve membership request" do
      before do
        controller.stub(:authorize!).and_return(true)
      end
      context 'request from signed-out user' do
        before { membership_request.stub(:requestor) }
        it 'marks the request as approved' do
          ManageMembershipRequests.should_receive(:approve!)
          post :approve, id: membership_request.id
        end
        it 'redirects to group with flash message' do
          post :approve, id: membership_request.id
          response.should redirect_to group_membership_requests_path(group)
          flash[:success].should == "#{membership_request.name}'s membership request has been approved. They will be added to the group once they set up a Loomio account."
        end
      end

      context 'request from signed-in user' do
        before { membership_request.stub(:requestor).and_return(requestor) }
        it 'marks the request as approved' do
          ManageMembershipRequests.should_receive(:approve!)
          post :approve, id: membership_request.id
        end
        it 'redirects to group with flash message' do
          post :approve, id: membership_request.id
          response.should redirect_to group_membership_requests_path(group)
          flash[:success].should == "#{membership_request.name}'s membership request has been approved. They have been added to the group."
        end
      end

      context "membership request has already been approved" do
        before do
          # membership_request.stub(:requestor)
          membership_request.stub(:response).and_return('approved')
        end
        it "redirects to group membership  requests index with flash message" do
          post :approve, id: membership_request.id
          flash[:warning].should == "This membership request has already been approved."
          response.should redirect_to group_membership_requests_path(group)
        end
      end
      context "membership request has been ignored" do
        it "redirects to group with flash message"
      end
      context "membership request has been cancelled" do
        it "redirects to group with flash message"
      end
    end
  end

  describe "ignore"
end
