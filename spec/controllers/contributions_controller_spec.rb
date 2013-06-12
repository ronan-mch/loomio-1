require 'spec_helper'

describe ContributionsController do
  before do
    controller.stub :authenticate_user!
    controller.stub :current_user => build_stubbed(User)
  end

  describe 'callback' do
    let(:params){
      {
        :email => "bill@james.com",
        :identifier_id => "15CD8F0D0E88E3",
        :item_quantity => "1",
        :item => "burrito",
        :response_message => "OK",
        :response_code => "200",
        :result => "accepted",
        :subscription => "created"
      }
    }

    before do
      get :callback, params
    end

    it 'redirects to show' do
      response.should redirect_to contribution_path(id: params[:identifier_id])
    end

    it 'records a contribution' do
      assigns(:contribution).should be_persisted
    end
  end

  describe 'show' do
    render_views
    it "renders a thank you page" do
      get :show, id: '123'
      response.body.should have_css(".contributions.show")
    end
  end
end
