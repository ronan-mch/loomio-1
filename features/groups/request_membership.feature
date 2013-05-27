Feature: Individual requests group membership
  As a signed in OR signed out individual
  So that I can participate in discussions I'm interested in
  I want to be able to join groups

  Scenario: Signed-out individual requests membership (Open group)
    Given I am not logged in
    And an open group exists
    When I visit the group page
    And I click "Request Membership"
    And I fill in and submit the 'Request Membership' form
    Then I should get an email with subject "Group Request received"
    And the group admins should receive an email with subject "new membership request"

    When a group admin approves my request
    Then I should get an email with subject "Membership approved"
    And the email should have an invitation token

  Scenario: Signed in user requests membership (Open group)
    Given I am logged in
    And an open group exists
    And I click "Request Membership"
    And I fill in and submit the 'Request Membership' form
    Then I should get an email with subject "Group Request received"
    And the group admins should receive an email with subject "new membership request"

    When a group admin approves my request
    Then I should get an email with subject "Membership approved"

  # Scenario: Signed out individual requests membership (Closed group)
  #   Given I am not logged in
  #   And a closed group exists
  #   When I visit the group page
  #   And I fill in and submit the 'Request to join group' form
  #   Then I should get an email with subject "Group Request received"
  #   And the group admins should receive an email with subject "requesting membership"

  #   When the group admins approve my request
  #   Then I should get an email with subject "Membership approved"
  #   # And the email should have an invitation token

  # Scenario: Signed in user requests membership (Closed group)
  #   Given I am logged in
  #   And a closed group exists
  #   When I visit the group page
  #   And I click "Request Membership"
  #   Then I should get an email with subject "Group Request received"
  #   And the group admins should receive an email with subject "requesting membership"

  #   When the group admins approve my request
  #   Then I should get an email with subject "Membership approved"
