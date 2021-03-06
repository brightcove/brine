Feature: Mathing
  It can be asserted that a value matches another string or regex.

  Scenario: String in response body is matched against a regex.
    When the response body is assigned:
      """
      http://www.github.com?var=val
      """
    Then the value of the response body is matching `/github/`
    And the value of the response body is matching `/git.*\?.*=/`
    And the value of the response body is not matching `/gh/`
    And the value of the response body is not matching `/^github/`

  Scenario: Regex in response body matched against a string
    When the response body is assigned:
      """
      /(.+)\1/
      """
    Then the value of the response body is matching `blahblah`
    And the value of the response body is matching `boo`
    And the value of the response body is not matching `blah blah`
    And the value of the response body is not matching `blah`
