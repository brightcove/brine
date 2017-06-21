Feature: Includes Assertion
  Backround
    Given brine is mixed

  Scenario: Equals
    Given a file named "features/includes.feature" with:
      """
Feature: Includes
  Scenario: Basic object membership
    When the response body is assigned:
      \"\"\"
      {"foo":"bar",
      "baz": 1,
      "other": "blah"}
      \"\"\"
    Then the value of the response body is including:
      \"\"\"
      {"baz":1}
      \"\"\"
    And the value of the response body is not including:
      \"\"\"
      {"missing":"value"}
      \"\"\"
      """
    When I run `cucumber features/includes.feature`
    Then the output should contain:
      """
      1 passed
      """
    And it should pass
