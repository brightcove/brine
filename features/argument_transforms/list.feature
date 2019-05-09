Feature: List
    An argument that could represent a JSON list will be
    transformed into a list whose elements will be also be transformed.

  Scenario Outline: Docstring simple list.
    When the response body is assigned:
      """
      <input>
      """
    Then the value of the response body is a valid `Array`
    And the value of the response body is equal to `<input>`

  Examples:
    | input                   |
    | []                      |
    | ["a", "b"]              |
    | ["a"  ,  "b" ]          |
    | ["  a", " b "]          |
    | [true, "false"]         |
    | [1,-3,"-5"]             |
    | ["foo,bar","baz"]       |
    | ["foo,bar,baz"]         |
    | ["foo\\"","bar"]        |
    | ["fo\\"o\\",bar","baz"] |
    | [{"i":1},{"i":2}, "h"]  |

  Scenario Outline: Inline simple list.
    When the response body is assigned `<input>`
    Then the value of the response body is a valid `Array`
    And the value of the response body is equal to `<input>`

  Examples:
    | input                   |
    | []                      |
    | ["a", "b"]              |
    | ["a"  ,  "b" ]          |
    | ["  a", " b "]          |
    | [true, "false"]         |
    | [1,-3,"-5"]             |
    | ["foo,bar","baz"]       |
    | ["foo,bar,baz"]         |
    | ["foo\\"","bar"]        |
    | ["fo\\"o\\",bar","baz"] |
    | [{"i":1},{"i":2}, "h"]  |
