class Groups::ManageMembershipRequestsController < GroupBaseController
  before_filter :load_group

  def index
    render 'groups/membership_requests/index'
  end

  def approve
    @membership_request = MembershipRequest.find(params[:manage_membership_request_id])
    @group = @membership_request.group
    if can? :manage_membership_requests, @group
      if @membership_requests.response == 'approved'
        flash[:warning] = "This membership request has already been approved."
      else
        ManageMembershipRequests.approve!(@membership_request, approved_by: current_user)
        set_request_approved_flash_message
      end
    else
      flash[:warning] = t("warning.user_not_admin", which_user: current_user.name)
    end
    redirect_to @group
  end

  def ignore
  end

  private

  def require_user_has_permission
    authorize! :manage_membership_requests, @group
  end

  def set_request_approved_flash_message
    if @membership_request.requestor.blank?
      flash[:alert] = "#{@membership_request.name}'s membership request has been approved. They will be added to the group once they set up a Loomio account." #needs_translation
    else
      flash[:alert] = "#{@membership_request.name}'s membership request has been approved. They have been added to the group." #needs_translation
    end
  end

end
