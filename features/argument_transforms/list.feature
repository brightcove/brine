Feature: List Argument Step Transform
  Backround
    Given brine is mixed

  Scenario Outline: assorted formats
    Given a file named "features/list_step.feature" with:
      """
Feature: Using an list argument
  Scenario: passing array
    When the response body contains the object:
      | val | <input>      |
    Then the raw response body is:
    \"\"\"
    {"val":<expected>}
    \"\"\"
      """
    When I run `cucumber features/list_step.feature`
    Then the output should contain:
      """
      2 passed
      """
    And it should pass

    Examples:
      | input           | expected       |
      | [a, b]          | ["a","b"]      |
      | ["a", "b"]      | ["a","b"]      |
      | [  a  , b ]     | ["a","b"]      |
      | ["  a", " b "]  | ["  a"," b "]  |
      | [a,b]           | ["a","b"]      |
      | [true, "false"] | [true,"false"] |
      | [1,-3,"-5"]     | [1,-3,"-5"]    |
