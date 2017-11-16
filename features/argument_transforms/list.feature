Feature: An argument that could represent a JSON list will be
    transformed into a list whose elements will be also be transformed.

  Scenario Outline: Assorted basic inputs are provided.
    Given a file named "features/transform_list.feature" with:
      """

Feature: Transform list arguments.
  Scenario: Docstring simple list.
    When the response body is assigned:
      \"\"\"
      <input>
      \"\"\"
    Then the response body as JSON is:
      \"\"\"
      '<expected>'
      \"\"\"

  Scenario: Inline simple list.
    When the response body is assigned `<input>`
    Then the response body as JSON is:
      \"\"\"
      '<expected>'
      \"\"\"

      """
    When I run `cucumber --strict features/transform_list.feature`
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
