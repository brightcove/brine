Feature: Object
  An argument that could represent a JSON object will be
  transformed into an object whose elements will also be transformed.

  Scenario Outline: Docstring simple object.
    When the response body is assigned:
      """
      <input>
      """
    Then the value of the response body is a valid `Object`
    And the value of the response body is equal to `<input>`

  Examples:
    | input                                               |
    | {}                                                  |
    | {"a":1}                                             |
    | {"foo":"bar", "num":1, "list": ["1", 2, true]}      |
    | {"foo": {"bar":{ "num":1, "list": ["1", 2, true]}}} |
    | {"foo": "\"list\": [\"1\", 2, true]"}               |

  Scenario Outline: Inline simple object.
    When the response body is assigned `<input>`

    Then the value of the response body is a valid `Object`
    And the value of the response body is equal to `<input>`

  Examples:
    | input                                               |
    | {}                                                  |
    | {"a":1}                                             |
    | {"foo":"bar", "num":1, "list": ["1", 2, true]}      |
    | {"foo": {"bar":{ "num":1, "list": ["1", 2, true]}}} |
    | {"foo": "\"list\": [\"1\", 2, true]"}               |
            
  Scenario: Object split over lines
    When the response body is assigned:
      """
      {
        "foo":"bar"
      }
      """
    Then the value of the response body is equal to:
      """
      {"foo":"bar"}
      """
