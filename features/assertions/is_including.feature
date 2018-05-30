Feature: Including
  It can be asserted that a value is a superset of another value.

  Scenario: Includes
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
    And the value of the response body is including `other`
    And the value of the response body is not including `brother`
    And the value of the response body is not including `value`

      """
    When I run `cucumber features/includes.feature`
    Then the output should contain:
      """
      1 passed
      """
    And it should pass
