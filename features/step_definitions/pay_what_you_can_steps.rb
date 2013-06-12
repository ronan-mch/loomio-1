Given(/^I am on the pay what you can page$/) do
  visit contributions_path
end

Given(/^my environment is set up$/) do
  RAILS_ENV = "test"
end

Given(/^I am not a member of a paying group$/) do
  @group = FactoryGirl.create :group, paying_subscription: false
  @group.save!
  @group.add_member! @user
end

Given(/^I am a member of a paying group$/) do
  @group = FactoryGirl.create :group, paying_subscription: true
  @group.save!
  @group.add_member! @user
end

When(/^I choose a monthly contribution of \$(\d+)$/) do |arg1|
  click_on "monthly-#{arg1}"
end

When(/^I choose a once\-off contribution of \$(\d+)$/) do |arg1|
  click_on "once-off-#{arg1}"
end

When(/^I submit a custom once\-off contribution in a foreign currency$/) do
  fill_in "custom_amount", with: "83"
  select "AUD"
  click_on "custom_amount_input"
end

When(/^I should see the SwipeHQ payment page for a monthly \$(\d+) payment$/) do |arg1|
  page.should have_content "$#{arg1} Monthly contribution"
end

When(/^I should see the SwipeHQ payment page for a once\-off \$(\d+) payment$/) do |arg1|
  page.should have_content "1 x contribution for $#{arg1}"
end

When(/^I should see the SwipeHQ payment page for a once\-off custom payment$/) do
  page.should have_content "1 x contribution for $83 AUD"
end

When(/^I visit the pay what you can page$/) do
  visit contributions_path
end

When(/^I fill in and submit the subscription payment page$/) do
  fill_in "one_acc", with: "1234"
  fill_in "two_acc", with: "1234"
  fill_in "three_acc", with: "1234"
  fill_in "four_acc", with: "1234"
  fill_in "fname", with: "Robidiah"
  fill_in "lname", with: "Guthrison"
  fill_in "address", with: "123 Maple St."
  fill_in "city", with: "Wellington"
  choose "card_type_visa"
  fill_in "name", with: "Robidiah Guthrison"
  fill_in "cvv", with: "123"
  fill_in "email", with: "robidiah.guthrison@hotmail.com"
  check "accept_terms"
  click_on "button"
end

When(/^I fill in and submit the product payment page$/) do
  fill_in "one_acc", with: "1234"
  fill_in "two_acc", with: "1234"
  fill_in "three_acc", with: "1234"
  fill_in "four_acc", with: "1234"
  choose "card_type_visa"
  fill_in "name", with: "Robidiah Guthrison"
  fill_in "cvv", with: "123"
  fill_in "email", with: "robidiah.guthrison@hotmail.com"
  click_on "button"
end

Then(/^I be should be redirected to the sign in page$/) do
  page.should have_css '.sessions.new'
end

Then(/^I should see a confirmation page thanking me for my contribution$/) do
  pending # can't be checked because of swipe callback
end

Then(/^I do not see the pay what you can icon in the navbar$/) do
  page.should_not have_css("#contribute")
end
