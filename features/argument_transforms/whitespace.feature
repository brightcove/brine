Feature: Leading and Trailing Whitespace Removal Transform
  Backround
    Given brine is mixed

  Scenario Outline: assorted formats
    Given a file named "features/whitespace_step.feature" with:
      """
Feature: Whitespace removal
  Scenario: passing array
    When the response body is:
    \"\"\"
    {"val": <input>}
    \"\"\"
    Then the response body as JSON is:
    \"\"\"
    '{"val":<expected>}'
    \"\"\"
      """
    When I run `cucumber features/whitespace_step.feature`
    Then the output should contain:
      """
      2 passed
      """
    And it should pass

    Examples:
      | input                     | expected     |
      | 	true              | true         |
      |   123	                  | 123          |
      |  ["a"]	                  | ["a"]        |
