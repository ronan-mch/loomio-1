class MembershipRequestsController < ApplicationController
  def new
    @group = Group.find(params[:group_id])
  end

  def create
  end
end
