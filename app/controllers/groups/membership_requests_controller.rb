class Groups::MembershipRequestsController < BaseController
  before_filter :load_group
  before_filter :authenticate_user!, except: [:new, :create]

  def new
    @membership_request = MembershipRequest.new group: @group
    render 'new'
  end

  # def create
  #   @membership_request = MembershipRequest.new params[:membership_request]
  #   if @group.has_member_with_email?(@membership_request.email)
  #     flash[:alert] = "You appear to already be a member of this group, try signing in." #needs_translation
  #   else
  #     if @group.has_membership_request_with_email?(@membership_request.email)
  #       flash[:alert] = "You have already requested to join this group." #needs_translation
  #     else
  #       save_membership_request
  #       flash[:success] = "Membership requested." #needs_translation
  #     end
  #   end
  #   redirect_to @group
  # end

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
