class MembershipRequestsController < ApplicationController
  def new
    @group = Group.find params[:group_id]
    @membership_request = MembershipRequest.new group: @group
  end

  def create
    membership_request = MembershipRequest.new params[:membership_request]
    @group = Group.find params[:group_id]
    membership_request.group = @group

    if membership_request.save!
      flash[:success]="Membership successfully requested"
    else
      flash[:failure]="nope"
    end
    # group_id     = params[:membership_request][:group_id]
    # name         = params[:membership_request][:name]
    # email        = params[:membership_request][:email]
    # introduction = params[:membership_request][:introduction]


    redirect_to @group
  end
end
