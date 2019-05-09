Feature: Boolean
  An argument that could represent a boolean value will be transformed into a boolean type.

  Scenario Outline: Docstring simple value.
    When the response body is assigned:
      """
      <input>
      """
    Then the value of the response body is a valid `Boolean`
    And the value of the response body is equal to `<input>`

  Examples:
    | input     |
    | true      |
    | false     |

  Scenario Outline: Inline simple value.
    When the response body is assigned `<input>`
    Then the value of the response body is a valid `Boolean`
    And the value of the response body is equal to `<input>`

  Examples:
    | input     |
    | true      |
    | false     |
