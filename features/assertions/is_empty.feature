Feature: Empty
  It can be asserted that a value is empty.

  Scenario: Empty body is empty.
    When the response body is assigned ``
    Then the value of the response body is empty

  Scenario: Whitespace-only body is empty.
    When the response body is assigned:
      """
             
      """
    Then the value of the response body is empty

  Scenario: Empty string is empty.
    When the response body is assigned `""`
    Then the value of the response body is empty

  Scenario: Non-empty string is not empty.
    When the response body is assigned `blah`
    Then the value of the response body is not empty

  Scenario: Quoted whitespace is not empty.
    When the response body is assigned `" "`
    Then the value of the response body is not empty

  Scenario: Empty arrays are empty.
    When the response body is assigned `[]`
    Then the value of the response body is empty

  Scenario: Non-empty arrays are not empty.
    When the response body is assigned `[[]]`
    Then the value of the response body is not empty

  Scenario: Empty objects are empty.
    When the response body is assigned `{}`
    Then the value of the response body is empty

  Scenario: Non-empty objects are not empty.
    When the response body is assigned `{"foo":{}}`
    Then the value of the response body is not empty

  Scenario: Null values are empty.
    When the response body is assigned `{"foo": null}`
    Then the value of the response body child `foo` is empty

  Scenario: False is not empty.
    When the response body is assigned `false`
    Then the value of the response body is not empty

  Scenario: 0 is not empty.
    When the response body is assigned `0`
    Then the value of the response body is not empty

