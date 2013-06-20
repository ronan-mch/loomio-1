class Groups::ManageMembershipRequestsController < GroupBaseController
  load_and_authorize_resource :membership_request, only: [:approve, :ignore], parent: false
  before_filter :load_group_and_check_for_response, only: [:approve, :ignore]

  def index
    @group = GroupDecorator.new Group.find(params[:group_id])
    if can? :manage_membership_requests, @group
      render 'groups/membership_requests/index'
    else
      redirect_to group_path(@group)
    end
  end

  def approve
    ManageMembershipRequests.approve!(@membership_request, approved_by: current_user)
    set_request_approved_flash_message
    redirect_to group_membership_requests_path(@group)
  end

  def ignore
    ManageMembershipRequests.ignore!(@membership_request, ignored_by: current_user)
    flash[:success] = "#{@membership_request.name}'s membership request has been ignored."
    redirect_to group_membership_requests_path(@group)
  end

  private

  def load_group_and_check_for_response
    @group = @membership_request.group
    response = @membership_request.response
    unless response.nil?
      if response == 'approved'
        flash[:warning] = "This membership request has already been approved." #needs_translation
      elsif response == 'ignored'
        flash[:warning] = "This membership request has already been ignored." #needs_translation
      end
      redirect_to group_membership_requests_path(@group)
    end
  end

  def set_request_approved_flash_message
    if @membership_request.requestor.blank?
      flash[:success] = "#{@membership_request.name}'s membership request has been approved. They will be added to the group once they set up a Loomio account." #needs_translation
    else
      flash[:success] = "#{@membership_request.name}'s membership request has been approved. They have been added to the group." #needs_translation
    end
  end

end
