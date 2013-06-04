require 'spec_helper'

describe Groups::MembershipRequestsController do

  describe "new" do
    context "invalid group id" do
      it "redirects to front page with error: group required" do
        get :new
        response.should redirect_to root_path
        flash[:alert].should =~ /invalid group/i
      end
    end

    context "valid group id" do
      let(:group) {mock_model Group}
      before do
        Group.stub(:find_by_id).and_return group
      end
      it "renders new template" do
        get :new, group_id: group.id
        response.should render_template 'new'
      end
    end
  end

  describe "create" do
    context "invalid group id" do
      it "redirects to front page with error: invalid group" do
        post :create
        response.should redirect_to root_path
        flash[:alert].should =~ /invalid group/i
      end
    end

    context "valid group id" do
      let(:group) {mock_model Group}
      let(:membership_request_args) {{name: 'bob james', email: 'bob@james.com', introduction: 'about me, hi'}}
      before do
        Group.stub(:find_by_id).and_return group
        group.stub(:has_member_with_email?).and_return false
        group.stub(:has_membership_request_with_email?).and_return false
      end

      context "signed-out user" do
        it "creates membership request with email and group" do
          post :create, group_id: group.id, membership_request: membership_request_args
          assigns(:membership_request).should be_persisted
        end
        it "redirects to group with flash success message" do
          post :create, group_id: group.id, membership_request: membership_request_args
          response.should redirect_to group_path(group)
          flash[:success].should =~ /Membership requested/i
        end
        context "membership request already exists for given email" do
          it "redirects to group with flash message: we already have a request for that email" do
            group.stub(:has_membership_request_with_email?).and_return true
            post :create, group_id: group.id, membership_request: membership_request_args
            response.should redirect_to group_path(group)
            flash[:alert].should =~ /already requested to join this group/i
          end
        end
      end

      context "signed-in user" do
        let(:user) {create(:user)}
        before do
          controller.stub(:current_user).and_return user
        end
        it "creates membership request with user and group" do
          post :create, group_id: group.id, membership_request: membership_request_args
          assigns(:membership_request).user_id.should == user.id
          assigns(:membership_request).should be_persisted
        end
        it "redirects to group with flash success message" do
          post :create, group_id: group.id, membership_request: membership_request_args
          response.should redirect_to group_path(group)
          flash[:success].should =~ /Membership requested/i
        end

        context "user is already a member" do
          before do
            group.stub(:has_member_with_email?).and_return true
          end
          it "does not create membership request" do
            post :create, group_id: group.id, membership_request: membership_request_args
            assigns(:membership_request).should_not be_persisted
          end
          it "redirects to group with flash message: already a member" do
            post :create, group_id: group.id, membership_request: membership_request_args
            response.should redirect_to group_path(group)
            flash[:alert].should =~ /appear to already be a member/i
          end
        end
      end
    end
  end

  describe "index"

  describe "approve", :focus do
    let(:group) { mock_model Group }
    let(:membership_request) { mock_model MembershipRequest }
    let(:coordinator) { create(:user) }

    before do
      controller.stub(:current_user).and_return coordinator
    end

    context "user doesn't have permission to approve membership request" do
      it 'redirects to group with flash alert' do
        post :approve, group_id: group.id, membership_request_id: membership_request.id
        response.should redirect_to group_path(group)
        flash[:alert].should =~ /Access denied/i
      end
      it 'does not add the user to the group' do
        group.should_not_receive(:add_member!)
        post :approve, group_id: group.id, membership_request_id: membership_request.id
      end
    end
    it 'redirects if membership request does not exist'

    it 'marks the request as approved'
    context 'request from signed-out user' do
      it 'creates invitation to user to join group'
    end

    context 'request from signed-in user' do
      it 'adds the user to the group'
      it 'notifies user that the request was accepted'
    end
  end

  describe "ignore"
end
