Feature: Including
  It can be asserted that a value is a superset of another value.  It can be asserted that a value is a superset of another value.  It can be asserted that a value is a superset of another value.  It can be asserted that a value is a superset of another value.

  Scenario: Basic object membership
    When the response body is assigned:
      """
      {"foo":"bar",
       "baz": 1,
       "other": "blah"}
      """
    Then the value of the response body is including:
      """
      {"baz": 1}
      """
    And the value of the response body is not including:
      """
      {"missing":"value"}
      """
    And the value of the response body is including `other`
    And the value of the response body is not including `brother`
    And the value of the response body is not including `value`
