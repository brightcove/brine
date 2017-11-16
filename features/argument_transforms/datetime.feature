Feature: An argument that could represent a date/time value will be
    transformed into a time type.

  Scenario: Assorted basic inputs are provided.
    Given a file named "features/transform_datetime.feature" with:
      """

Feature: Transform date/time arguments.
  Scenario: Docstring datetime is serialized properly.
    When the response body is assigned:
      \"\"\"
      2017-01-01T09:00:00Z
      \"\"\"
    Then the response body as JSON is:
      \"\"\"
      '"2017-01-01 09:00:00 UTC"'
      \"\"\"

  Scenario: Inline datetime is serialized properly.
    When the response body is assigned `2017-01-01T09:00:00Z`
    Then the response body as JSON is:
      \"\"\"
      '"2017-01-01 09:00:00 UTC"'
      \"\"\"

  Scenario: Value Comparison
    When `now` is assigned a timestamp
    And `then` is assigned `2017-01-01T12:00:00Z`
    Then the value of `{{then}}` is less than `{{now}}`

  Scenario: Child Comparison
    When `now` is assigned a timestamp
    And the response body is assigned:
      \"\"\"
      {"my_timestamp": "{{now}}"}
      \"\"\"
    Then the value of the response body child `my_timestamp` is greater than `2017-01-01T12:00:00Z`

      """
    When I run `cucumber --strict features/transform_datetime.feature`
    Then the output should contain:
      """
      4 passed
      """
    And it should pass
