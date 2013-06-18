Feature: Individual requests group membership
  As a signed in OR signed out individual
  So that I can participate in discussions I'm interested in
  I want to be able to join groups

  # @javascript
  Scenario: Signed-out individual requests membership (Open group)
    Given I am not logged in
    And an open group exists
    When I visit the group page
    And I click "Request membership"
    And I fill in and submit the Request membership form
    Then I should see a flash message confirming my membership request

  # @javascript
  Scenario: Signed-in individual requests membership (Open group)
    Given I am logged in
    And an open group exists
    When I visit the group page
    And I click "Request membership"
    And fill in and submit the Request membership form (introduction only)
    Then I should see a flash message confirming my membership request


  # @javascript
  Scenario: A member with permission approves membership request from signed-out user
    Given there is a membership request from a signed-out user
    And I am a logged in coordinator of the group
    When I approve the membership request
    Then I should see a flash message confirming the membership request was approved
    And I should no longer see the membership request in the list
    And the requester should be sent an invitation to join the group

  Scenario: A member with permission approves membership request from signed-in user
    Given there is a membership request from a signed-in user
    And I am a logged in coordinator of the group
    When I approve the membership request
    Then I should see a flash message confirming the membership request was approved
    And I should no longer see the membership request in the list
    And the requester should be added to the group

  Scenario: A member with permission tries to approve a request which has already been responded to
    Given there is an approved membership request from a signed-in user
    And I am a logged in coordinator of the group
    When I visit the membership requests page for the group
    Then I should not see the membership request in the list

  Scenario: A non-member tries to visit the membership requests page of the group
    Given there is a membership request from a signed-in user
    And I am logged in
    When I try to visit the membership requests page for the group
    Then I should be returned to the group page

  Scenario: An unauthorized member tries to visit the membership requests page of the group
    Given there is a membership request from a signed-in user
    And membership requests can only be managed by group admins for the group
    And I am a member of the group
    And I am logged in
    When I try to visit the membership requests page for the group
    Then I should be returned to the group page
