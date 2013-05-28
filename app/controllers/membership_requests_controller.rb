class MembershipRequestsController < ApplicationController
  def new
    @group = Group.find(params[:group_id])
    @membership_request = MembershipRequest.new#(group: @group)
  end

  def create
  end
end
