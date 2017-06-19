Feature: Integer Step Argument Transform
  Backround
    Given brine is mixed

  Scenario Outline: Assorted Inputs
    Given a file named "features/integer_transform.feature" with:
      """
Feature: Using an integer argument
  Scenario: passing Integer
    When the response body is assigned:
    \"\"\"
    <input>
    \"\"\"
    Then the response body as JSON is:
    \"\"\"
    '<expected>'
    \"\"\"
      """
    When I run `cucumber features/integer_transform.feature`
    Then the output should contain:
      """
      2 passed
      """
    And it should pass

    Examples:
      |               input |            expected |
      |                   0 |                   0 |
      |                  -0 |                   0 |
      |                  10 |                  10 |
      |                 -10 |                 -10 |
      |  123456789123456789 |  123456789123456789 |
      | -123456789123456789 | -123456789123456789 |
