Feature: Whitespace Removal Step Argument Transform
  Backround
    Given brine is mixed

  Scenario Outline: Assorted Inputs
    Given a file named "features/whitespace_transform.feature" with:
      """
Feature: Whitespace removal
  Scenario: Assorted Inputs
    When the response body is assigned:
    \"\"\"
    <input>
    \"\"\"
    Then the response body as JSON is:
    \"\"\"
    '<expected>'
    \"\"\"

  Scenario: passing input with extra lines
    When the response body is:
    \"\"\"

    <input>

    \"\"\"
    Then the response body as JSON is:
    \"\"\"
    '<expected>'
    \"\"\"

      """
    When I run `cucumber features/whitespace_transform.feature`
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
