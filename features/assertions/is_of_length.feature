Feature: Of Length
  It can be asserted that a value has a provided length.

  Scenario: Has Length
    Given a file named "features/has_length.feature" with:
      """

Feature: Has Length
  Scenario: String
    When the response body is assigned:
      \"\"\"
      blah
      \"\"\"
    Then the value of the response body is of length `4`

  Scenario: Array
    When the response body is assigned:
      \"\"\"
      ["foo", "blah"]
      \"\"\"
    Then the value of the response body is of length `2`

  Scenario: Map
    When the response body is assigned:
      \"\"\"
      {"foo": "blah"}
      \"\"\"
    Then the value of the response body is of length `1`

  Scenario: Value without length attribute
    When the response body is assigned:
      \"\"\"
      true
      \"\"\"
    Then the value of the response body is not of length `1`

      """
    When I run `cucumber features/has_length.feature`
    Then the output should contain:
      """
      4 passed
      """
    And it should pass
