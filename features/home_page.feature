Feature: Home page

  Scenario: Viewing application's home page
    Given there's a source named "Default Source"
    When I am on the homepage
    Then I should see the "Default Source" source
