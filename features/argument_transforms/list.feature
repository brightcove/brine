Feature: JSON List Step Argument Transform
  Backround
    Given brine is mixed

  Scenario Outline: Assorted Inputs
    Given a file named "features/list_transform.feature" with:
      """
Feature: Using an list argument
  Scenario: passing array
    When the response body is assigned:
    \"\"\"
    <input>
    \"\"\"
    Then the response body as JSON is:
    \"\"\"
    '<expected>'
    \"\"\"
      """
    When I run `cucumber features/list_transform.feature`
    Then the output should contain:
      """
      2 passed
      """
    And it should pass

    Examples:
      | input                   | expected                |
      | []                      | []                      |
      | ["a", "b"]              | ["a","b"]               |
      | ["a"  ,  "b" ]          | ["a","b"]               |
      | ["  a", " b "]          | ["  a"," b "]           |
      | [true, "false"]         | [true,"false"]          |
      | [1,-3,"-5"]             | [1,-3,"-5"]             |
      | ["foo,bar","baz"]       | ["foo,bar","baz"]       |
      | ["foo,bar,baz"]         | ["foo,bar,baz"]         |
      | ["foo\\"","bar"]        | ["foo\\"","bar"]        |
      | ["fo\\"o\\",bar","baz"] | ["fo\\"o\\",bar","baz"] |
      | [{"i":1},{"i":2}, "h"]  | [{"i":1},{"i":2},"h"]   |
