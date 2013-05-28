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
    # And screenshot
    And I fill in and submit the Request membership form
    Then I should see a flash message confirming my membership request

  Scenario: Group coordinator approves membership request from signed-out user
    Given there is a membership request from a signed-out user
    And I am a coordinator of the group
    When I approve the membership request
    Then the requester should be sent an invitation to join the group
    And I should see the membership request was approved



  Scenario: Signed-out individual requests membership (Open group)
    Given I am logged in
    And an open group exists
    When I visit the group page
    And I click "Request membership"
    And I fill in and submit the Request membership form
    Then I should see a flash message confirming my membership request

  Scenario: Group coordinator approves membership request from signed-out user
    Given there is a membership request from a signed-in user
    And I am a coordinator of the group
    When I approve the membership request
    Then the requester should be added to the group
    And I should see the membership request was approved
