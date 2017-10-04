Feature: Matching
  It can be asserted that a value matches another string or regex

  Background
    Given brine is mixed

  Scenario: Assorted positive and negative assertions.
    Given a file named "features/is_matching.feature" with:
      """

Feature: Assert value matchiness
  Scenario: String in response body matched against a regex
    When the response body is assigned:
      \"\"\"
      http://www.github.com?var=val
      \"\"\"
    Then the value of the response body is matching `/github/`
    And the value of the response body is matching `/git.*\?.*=/`
    And the value of the response body is not matching `/gh/`
    And the value of the response body is not matching `/^github/`

  Scenario: Regex in response body matched against a string
    When the response body is assigned:
      \"\"\"
      /(.+)\1/
      \"\"\"
    Then the value of the response body is matching `blahblah`
    And the value of the response body is matching `boo`
    And the value of the response body is not matching `blah blah`
    And the value of the response body is not matching `blah`

      """
    When I run `cucumber --strict features/is_matching.feature`
    Then the output should contain:
      """
      2 passed
      """
    And it should pass