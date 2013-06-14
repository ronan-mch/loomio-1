class ManageMembershipRequests

  def self.approve!(membership_request, options={})
    responder = options[:approved_by]
    requestor = membership_request.requestor
    membership_request.approved_by!(responder)
    if requestor.blank?
      invitation = CreateInvitation.after_membership_request_approval(
                        recipient_email: membership_request.email,
                        inviter: responder,
                        group: membership_request.group)
      InvitePeopleMailer.after_membership_request_approval(invitation, responder.email,'').deliver
    else
      group = membership_request.group
      group.add_member! requestor
      membership = group.memberships.find_by_user_id(requestor.id)
      Events::UserAddedToGroup.publish!(membership)
    end
  end
end
