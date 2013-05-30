class Groups::MembershipRequestsController < ApplicationController

  before_filter :load_group_or_redirect_to_root

  def new
    @membership_request = MembershipRequest.new group: @group
  end

  def create
    @membership_request = MembershipRequest.new params[:membership_request]
    @membership_request.group = @group
    @membership_request.save
  end

  def show
    @group = Group.find params[:group_id]
  end

  def approve

  end

  # def approve_request
  #   @membership = Membership.find(params[:id])
  #   if @membership.request?
  #     @membership.approve!
  #     flash[:notice] = t("notice.membership_approved")
  #     UserMailer.group_membership_approved(@membership.user, @membership.group).deliver
  #   else
  #     flash[:warning] = t("warning.user_already_member")
  #   end
  #   redirect_to @membership.group
  # end

  private

  def load_group_or_redirect_to_root
    @group = Group.find_by_id(params[:group_id])
    unless @group.present?
      flash[:alert] = "Invalid group"
      redirect_to root_path
    end
  end

end
