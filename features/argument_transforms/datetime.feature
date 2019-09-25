Feature: DateTime
  An argument that could represent a date/time value will be transformed into a time type.

  Scenario: Docstring datetime is serialized properly.
    When the response body is assigned:
      """
      2017-01-01T09:00:00Z
      """
    Then the value of the response body is a valid `DateTime`
    And the value of the response body is equal to `2017-01-01T09:00:00Z`
    And the value of the response body is greater than `2017-01-01T08:00:00Z`
    And the value of the response body is less than `2017-01-01T10:00:00Z`

  Scenario: Inline datetime is serialized properly.
    When the response body is assigned `2017-01-01T09:00:00Z`
    Then the value of the response body is a valid `DateTime`
    And the value of the response body is equal to `2017-01-01T09:00:00Z`
    And the value of the response body is greater than `2017-01-01T08:00:00Z`
    And the value of the response body is less than `2017-01-01T10:00:00Z`

  Scenario: Value Comparison
    When `now` is assigned a timestamp
    And `then` is assigned `2017-01-01T12:00:00Z`
    Then the value of `{{ then }}` is less than `{{ now }}`

  @pending @170
  Scenario: Child Comparison
    When `now` is assigned a timestamp
    And the response body is assigned:
      """
      {"my_timestamp": "{{ now }}"}
      """
    Then the value of the response body child `my_timestamp` is greater than `2017-01-01T12:00:00Z`
