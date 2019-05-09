Feature: Quoted
  An argument that is quoted will be (not) transformed into
  into a string, regardless of any more specific data type the
  quoted value may resemble.

  Scenario Outline: Docstring simple value.
    When the response body is assigned:
      """
      <input>
      """
    Then the value of the response body is a valid `String`
    And the value of the response body is equal to `<input>`

  Examples:
    | input               |
    | "true"              |
    | "123"               |
    | " -123 "            |
    | "["foo","bar"]"     |
    | "{"foo":"bar"}"     |

  Scenario Outline: Inline simple value.
    When the response body is assigned `<input>`

    Then the value of the response body is a valid `String`
    And the value of the response body is equal to `<input>`

  Examples:
    | input               |
    | "true"              |
    | "123"               |
    | " -123 "            |
    | "["foo","bar"]"     |
    | "{"foo":"bar"}"     |
