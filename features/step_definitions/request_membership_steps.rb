When(/^I fill in and submit the Request membership form$/) do
  fill_in 'membership_request_name', with: "John d'Wayne"
  fill_in 'membership_request_email', with: "John.d'Wayne@gmail.com"
  fill_in 'membership_request_introduction', with: "Please add me to your group, it seems like the best decission making forum ever."
  click_on "Request membership"
end

Then(/^I should see a flash message confirming my membership request$/) do
  find('.alert-success').should have_content('Membership successfully requested')
end

Given(/^there is a membership request from a signed\-out user$/) do
  @membership_request = FactoryGirl.create :membership_request
  @group = @membership_request.group
end

Given(/^I am a coordinator of the group$/) do
  @admin = @group.admins.first
end
