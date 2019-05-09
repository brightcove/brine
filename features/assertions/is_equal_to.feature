Feature: Equal To
  It can be asserted that a value is equal to another value.

  Scenario: String in response body
    When the response body is assigned:
      """
      foo
      """
    Then the value of the response body is equal to `foo`
    And the value of the response body is not equal to `foot`

  Scenario: Response Status
    When the response status is assigned `404`
    Then the value of the response status is equal to `404`
    And the value of the response status is not equal to `200`

  Scenario: Object in response body
    When the response body is assigned:
      """
      {
        "foo": "bar"
      }
      """
    Then the value of the response body is equal to:
      """
      {"foo":"bar"}
      """
    And the value of the response body is not equal to:
      """
      {"foo": "baz"}
      """

  Scenario: List in response body
    When the response body is assigned `[1, "foo", true]`
    Then the value of the response body is equal to `[1, "foo", true]`
    And the value of the response body is not equal to `[1, "bar", true]`

  Scenario Outline: Objects must match completely
    When the response body is assigned `{"foo": "bar", "baz": 1}`
    Then the value of the response body is not equal to `<comparison>`

  Examples:
    | comparison                           |
    | {}                                   |
    | {"foo": "bar"}                       |
    | {"foo": "bar", "baz": 1, "extra": 2} |
    | {"foo": "bar", "baz": 2}             |
