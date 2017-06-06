Feature: Quoted String Step Argument Transform
  Backround
    Given brine is mixed

  Scenario Outline: Assorted Inputs
    Given a file named "features/quoted_transform.feature" with:
      """
Feature: Quoted Strings
  Scenario: passing input
    When the response body is assigned:
    \"\"\"
    <input>
    \"\"\"
    Then the response body as JSON is:
    \"\"\"
    '<expected>'
    \"\"\"
      """
    When I run `cucumber features/quoted_transform.feature`
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
