Feature: Pay what you can
  As a Loomio user
  So that I can support the project
  I would like to pay a monetary contribution to Loomio

  @javascript
  Scenario: Signed in user pays a monthly contribution
    Given I am logged in
    And I am not a member of a paying group
    And my environment is set up
    And I am on the pay what you can page
    When I choose a monthly contribution of $5
    And I should see the SwipeHQ payment page for a monthly $5 payment
    And I fill in and submit the subscription payment page
    Then I should see a confirmation page thanking me for my contribution

  @javascript
  Scenario: Signed in user pays a once-off contribution
    Given I am logged in
    And I am not a member of a paying group
    And my environment is set up
    And I am on the pay what you can page
    When I choose a once-off contribution of $50
    And I should see the SwipeHQ payment page for a once-off $50 payment
    And I fill in and submit the product payment page
    Then I should see a confirmation page thanking me for my contribution

  @javascript
  Scenario: Signed in user pays a custom once-off contribution in foreign currency
    Given I am logged in
    And I am not a member of a paying group
    And my environment is set up
    And I am on the pay what you can page
    When I submit a custom once-off contribution in a foreign currency
    And I should see the SwipeHQ payment page for a once-off custom payment
    And I fill in and submit the product payment page
    Then I should see a confirmation page thanking me for my contribution

  Scenario: Signed out user attempts to make a contribution
    When I visit the pay what you can page
    Then I be should be redirected to the sign in page

  Scenario: User is a member of in a paying group
    Given I am logged in
    And I am a member of a paying group
    And I visit the group page
    Then I do not see the pay what you can icon in the navbar
