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
      context "signed-out user" do
        let(:group) {mock_model Group}
        let(:membership_request) {{name: 'bob james', email: 'bob@james.com', introduction: 'about me, hi'}}
        before do
          Group.stub(:find_by_id).and_return group
        end
        it "creates membership request with email and group" do
          post :create, group_id: group.id, membership_request: membership_request
          assigns(:membership_request).should be_persisted
        end
        it "redirects to group with flash success message"
        context "membership request already exists for given email" do
          it "redirects to group with flash message: we already have a request for that email"
        end
      end
      context "signed-in user" do
        it "creates membership request with user and group" do
        end
        it "redirects to group with flash success message"
        context "user is already a member" do
          it "redirects to group with flash message: already a member"
        end
      end
    end
  end

end
