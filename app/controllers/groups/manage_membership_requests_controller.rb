class Groups::ManageMembershipRequestsController < BaseController

  def index
  end

  def approve
    @membership_request = MembershipRequest.find(params[:id])
    @group = @membership_request.group
    if can? :manage_membership_requests, @group
      ManageMembershipRequests.approve!(@membership_request, approved_by: current_user)
      flash[:alert] = "#{@membership_request.name}'s membership request has been approved. They will be added to the group once they set up a Loomio account." #needs_translation
    else
      flash[:warning] = t("warning.user_not_admin", which_user: current_user.name)
    end
    redirect_to @group
  end

  def ignore
  end

  private

end
