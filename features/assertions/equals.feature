@wip
Feature: Equals Assertion
  Backround
    Given brine is mixed

  Scenario: Equals
    Given a file named "features/equals.feature" with:
      """
Feature: Equals
  Scenario: Response Body
    When the response body is assigned:
      \"\"\"
      foo
      \"\"\"
    Then the value of the response body is equal to `foo`
    And the value of the response body is not equal to `foot`
  Scenario: Response Status
    When the response status is assigned `404`
    Then the value of the response status is equal to `404`
    And the value of the response status is not equal to `200`
  Scenario: Multiline
    When the response body is assigned:
      \"\"\"
      {"foo":"bar"}
      \"\"\"
    Then the value of the response body is equal to:
      \"\"\"
      {"foo":"bar"}
      \"\"\"
      """
    When I run `cucumber features/equals.feature`
    Then the output should contain:
      """
      3 passed
      """
    And it should pass
