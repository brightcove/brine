Feature:Quoted String Transform
  Backround
    Given brine is mixed

  Scenario Outline: Assorted Inputs
    Given a file named "features/quoted.feature" with:
      """
Feature: Quoted Strings
  Scenario: passing input
    When the response body is:
    \"\"\"
    <input>
    \"\"\"
    Then the response body as JSON is:
    \"\"\"
    '<expected>'
    \"\"\"
      """
    When I run `cucumber features/quoted.feature`
    Then the output should contain:
      """
      2 passed
      """
    And it should pass

    Examples:
      | input               | expected            |
      | "true"              | "true"              |
      | "123"               | "123"               |
      | " -123 "            | " -123 "            |
      | "["foo","bar"]"     | "[\"foo\",\"bar\"]" |
      | "{"foo":"bar"}"     | "{\"foo\":\"bar\"}" |
