class Groups::MembershipRequestsController < ApplicationController
  inherit_resources
  before_filter :load_group_or_redirect_to_root
  before_filter :require_current_user_is_group_admin, except: [:new, :create]

  def new
    @membership_request = MembershipRequest.new group: @group
    render 'groups/membership_requests/new'
  end

  def create
    @membership_request = MembershipRequest.new params[:membership_request]
    if @group.has_member_with_email?(@membership_request.email)
      flash[:alert] = "You appear to already be a member of this group, try signing in." #needs_translation
    else
      if @group.has_membership_request_with_email?(@membership_request.email)
        flash[:alert] = "You have already requested to join this group." #needs_translation
      else
        save_membership_request
        flash[:success] = "Membership requested." #needs_translation
      end
    end
    redirect_to @group
  end

  def index
  end

  def approve
    
  end

  def ignore
  end


  private

  def save_membership_request
    @membership_request.group = @group
    @membership_request.user = current_user if user_signed_in?
    @membership_request.save
  end

  def load_group_or_redirect_to_root
    @group = Group.find_by_id(params[:group_id])
    unless @group.present?
      flash[:alert] = "Invalid group." #needs_translation
      redirect_to root_path
    end
  end
end
