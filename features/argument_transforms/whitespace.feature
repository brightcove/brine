Feature: Whitespace
  An argument that includes leading or trailing whitespace
  will be transformed so that such whitespace is removed
  and that value will also be transformed.

  Scenario Outline: Docstring simple value.
    When the response body is assigned:
      """
      <input>
      """
    Then the value of the response body is equal to `<expected>`

  Scenario Outline: Inline simple value.
    When the response body is assigned `<input>`
    Then the value of the response body is equal to `<expected>`

  Examples:
    | input              | expected     |
    | 	true             | true         |
    |   123	         | 123          |
    |  ["a"]	         | ["a"]        |

  Scenario Outline: Docstring value with a leading and trailing line.
    When the response body is assigned:
      """

      <input>

      """
    Then the value of the response body is equal to `<expected>`

  Examples:
    | input              | expected     |
    | 	true             | true         |
    |   123	         | 123          |
    |  ["a"]	         | ["a"]        |
