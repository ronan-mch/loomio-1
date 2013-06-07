class Groups::MembershipRequestsController < BaseController
  before_filter :load_group
  before_filter :authenticate_user!, except: [:new, :create]

  def new
    @membership_request = MembershipRequest.new(group: @group)
    @membership_request.user = current_user
    render 'new'
  end

  def create
    build_membership_request
    if @membership_request.save
      flash[:success] = "Membership requested." #needs_translation
      redirect_to @group
    else
      render 'new'
    end
  end

  private

  def load_group
    @group ||= Group.find(params[:group_id])
  end

  def build_membership_request
    @membership_request = MembershipRequest.new params[:membership_request]
    @membership_request.group = @group
    @membership_request.user = current_user if user_signed_in?
  end
end
