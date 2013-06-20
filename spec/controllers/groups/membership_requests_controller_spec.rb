require 'spec_helper'

describe Groups::MembershipRequestsController do
  describe "#new" do
    let(:group) { mock_model(Group) }
    it "renders new template" do
      Group.stub(:find).and_return group
      get :new, group_id: group.id
      response.should render_template 'new'
    end
  end

  describe "#create" do
    let(:group) { mock_model(Group) }
    let(:membership_request) { stub_model(MembershipRequest) }
    # let(:membership_request_args) {{name: 'bob james', email: 'bob@james.com', introduction: 'about me, hi'}}
    before do
      Group.stub(find: group)
      MembershipRequest.stub(new: membership_request)
    end

    context "saves successfully" do
      it "gives flash message and redirects to group" do
        membership_request.stub(save: true)
        post :create, group_id: group.id, membership_request: membership_request_args
        flash[:success].should =~ /Membership requested/i
        response.should redirect_to group_path(group)
      end
    end

    context "doesn't save successfully" do
      it "renders the 'new' action" do
        membership_request.stub(save: false)
        post :create, group_id: group.id, membership_request: membership_request_args
        response.should render_template 'new'
      end
    end

    context "signed-out user" do
      # it "creates membership request with email and group" do
      #   post :create, group_id: group.id, membership_request: membership_request_args
      #   assigns(:membership_request).should be_persisted
      # end
      # it "redirects to group with flash success message" do
      #   post :create, group_id: group.id, membership_request: membership_request_args
      #   response.should redirect_to group_path(group)
      #   flash[:success].should =~ /Membership requested/i
      # end
      # context "membership request already exists for given email" do
      #   it "redirects to group with flash message: we already have a request for that email" do
      #     post :create, group_id: group.id, membership_request: membership_request_args
      #     response.should redirect_to group_path(group)
      #     flash[:alert].should =~ /already requested to join this group/i
      #   end
      # end
    end

    context "signed-in user" do
    #   let(:user) {create(:user)}
    #   before do
    #     controller.stub(:current_user).and_return user
    #   end
    #   it "creates membership request with user and group" do
    #     post :create, group_id: group.id, membership_request: membership_request_args
    #     assigns(:membership_request).user_id.should == user.id
    #     assigns(:membership_request).should be_persisted
    #   end
    #   it "redirects to group with flash success message" do
    #     post :create, group_id: group.id, membership_request: membership_request_args
    #     response.should redirect_to group_path(group)
    #     flash[:success].should =~ /Membership requested/i
    #   end

    #   context "user is already a member" do
    #     before do
    #       group.stub(:has_member_with_email?).and_return true
    #     end
    #     it "does not create membership request" do
    #       post :create, group_id: group.id, membership_request: membership_request_args
    #       assigns(:membership_request).should_not be_persisted
    #     end
    #     it "redirects to group with flash message: already a member" do
    #       post :create, group_id: group.id, membership_request: membership_request_args
    #       response.should redirect_to group_path(group)
    #       flash[:alert].should =~ /appear to already be a member/i
    #     end
    #   end
    end
  end

  describe '#cancel', :focus do
    let(:requestor) { create(:user) }
    let(:group) { mock_model Group }
    let(:membership_request) { mock_model MembershipRequest, group: group, requestor_id: requestor.id }

    before do
      MembershipRequest.stub(:find).with(membership_request.id.to_s).and_return(membership_request)
      Group.stub(:find).and_return(group)
      membership_request.stub(:destroy)
      controller.stub(:current_user).and_return requestor
      sign_in requestor
    end

    context "a user has permission to cancel membership request" do
      before { controller.stub(:authorize!).with(:cancel, membership_request).and_return(true) }
      it "destroys the membership request" do
        membership_request.should_receive(:destroy)
        post :cancel, id: membership_request.id
      end
      it "redirects them to group page with success flash"
    end
    context "a user doesn't have permission to cancel membership request" do
      before { membership_request.stub(:requestor_id).and_return(requestor.id+1) }
      it "doesn't destroy the membership request" do
        membership_request.should_not_receive(:destroy)
        post :cancel, id: membership_request.id
      end
      it "redirect user to group page with error flash"
    end
  end
end
