class ManageMembershipRequests

  def self.approve!(membership_request, options={})
    responder = options[:approved_by]
    membership_request.approved_by!(responder)
    if membership_request.requestor.blank?
      invitation = CreateInvitation.after_membership_request_approval(
                        recipient_email: membership_request.email,
                        inviter: responder,
                        group: membership_request.group)
      InvitePeopleMailer.after_membership_request_approval(invitation, responder.email,'').deliver
    else
      group = membership_request.group
      group.add_member! membership_request.requestor
      Events::MembershipRequestApproved.publish!(membership_request)
    end
  end
end
