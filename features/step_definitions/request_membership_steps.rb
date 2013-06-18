When(/^I fill in and submit the Request membership form$/) do
  fill_in 'membership_request_name', with: "John d'Wayne"
  fill_in 'membership_request_email', with: "John.d'Wayne@gmail.com"
  fill_in 'membership_request_introduction', with: "Please add me to your group, it seems like the best decission making forum ever."
  click_on "Request membership"
end

When(/^fill in and submit the Request membership form \(introduction only\)$/) do
  fill_in 'membership_request_introduction', with: "Please add me to your group, it seems like the best decission making forum ever."
  click_on "Request membership"
end

Then(/^I should see a flash message confirming my membership request$/) do
  find('.alert-success').should have_content('Membership requested')
end

Then(/^I should see a flash message confirming the membership request was approved$/) do
  find('.alert-success').should have_content('membership request has been approved')
end

Then(/^I should see a flash message confirming the membership request was ignored$/) do
  find('.alert-success').should have_content('membership request has been ignored')
end

Given(/^there is a membership request from a signed\-out user$/) do
  @membership_request = FactoryGirl.create :membership_request
  @group = @membership_request.group
end

Given(/^there is a membership request from a signed\-in user$/) do
  step 'there is a membership request from a signed-out user'
  @membership_request.requestor = FactoryGirl.create :user
  @membership_request.save
end

Given(/^I am a logged in coordinator of the group$/) do
  @admin = @group.admins.first
  login @admin
end

When(/^I approve the membership request$/) do
  visit group_membership_requests_path(@group)
  click_on "approve-membership-request-#{@membership_request.id}"
  # click_on "confirm-action"
end

When(/^I ignore the membership request$/) do
  visit group_membership_requests_path(@group)
  click_on "ignore-membership-request-#{@membership_request.id}"
  # click_on "confirm-action"
end

Then(/^the requester should be sent an invitation to join the group$/) do
  last_email = ActionMailer::Base.deliveries.last
  last_email.to.should include @membership_request.email
  last_email.subject.should include 'has invited you to join'
end

Then(/^the requester should be added to the group$/) do
  @group.members.include?(@membership_request.requestor)
end

Then(/^I should no longer see the membership request in the list$/) do
  find('#membership-request-list').should_not have_content @membership_request.name
end

Given(/^there is an approved membership request from a signed-in user$/) do
  step 'there is a membership request from a signed-out user'
  @membership_request.response = 'approved'
  @membership_request.save!
end

When(/^I visit the membership requests page for the group$/) do
  visit group_membership_requests_path(@group)
end

When(/^I try to visit the membership requests page for the group$/) do
  step 'I visit the membership requests page for the group'
end

Then(/^I should not see the membership request in the list$/) do
  step 'I should no longer see the membership request in the list'
end

Then(/^I should be returned to the group page$/) do
  page.should have_css('body.groups.show')
end

Given(/^membership requests can only be managed by group admins for the group$/) do
  @group.members_invitable_by = 'admins'
  @group.save
end

Given(/^I am a member of the group$/) do
  @user ||= FactoryGirl.create :user
  @group.add_member!(@user)
end
