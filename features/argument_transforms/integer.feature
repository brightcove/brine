Feature: Integer
  An argument that could represent an integer will be transformed into an integer type.

  Scenario Outline: Docstring simple value.
    When the response body is assigned:
      """
      <input>
      """
    Then the value of the response body is a valid `Integer`
    And the value of the response body is equal to `<input>`

  Examples:
    |               input |
    |                   0 |
    |                  -0 |
    |                  10 |
    |                 -10 |
    |  123456789123456789 |
    | -123456789123456789 |

  Scenario Outline: Inline simple value.
    When the response body is assigned `<input>`
    Then the value of the response body is a valid `Integer`
    And the value of the response body is equal to `<input>`

  Examples:
    |               input |
    |                   0 |
    |                  -0 |
    |                  10 |
    |                 -10 |
    |  123456789123456789 |
    | -123456789123456789 |
