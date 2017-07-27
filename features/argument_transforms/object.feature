Feature: An argument that could represent a JSON object will be
    transformed into an object whose elements will also be transformed.

  Backround
    Given brine is mixed

  Scenario Outline: Assorted basic inputs are provided.
    Given a file named "features/transform_object.feature" with:
      """

Feature: Transform object arguments.
  Scenario: Docstring simple object.
    When the response body is assigned:
      \"\"\"
      <input>
      \"\"\"
    Then the response body as JSON is:
      \"\"\"
      '<expected>'
      \"\"\"

  Scenario: Inline simple object.
    When the response body is assigned `<input>`
    Then the response body as JSON is:
      \"\"\"
      '<expected>'
      \"\"\"

      """
    When I run `cucumber features/transform_object.feature`
    Then the output should contain:
      """
      2 passed
      """
    And it should pass

    Examples:
      | input                                               | expected                                      |
      | {}                                                  | {}                                            |
      | {"a":1}                                             | {"a":1}                                       |
      | {"foo":"bar", "num":1, "list": ["1", 2, true]}      | {"foo":"bar","num":1,"list":["1",2,true]}     |
      | {"foo": {"bar":{ "num":1, "list": ["1", 2, true]}}} | {"foo":{"bar":{"num":1,"list":["1",2,true]}}} |
      | {"foo": "\"list\": [\"1\", 2, true]"}               | {"foo":"\\"list\\": [\\"1\\", 2, true]"}      |
            
  Scenario: Passed an Object split over multiple lines
    Given a file named "features/transform_object_splitline.feature" with:
      """

Feature: Using an object argument split over multiple lines
  Scenario: Object split over lines
    When the response body is assigned:
      \"\"\"
      {
        "foo":"bar"
      }
      \"\"\"
    Then the value of the response body is equal to:
      \"\"\"
      {"foo":"bar"}
      \"\"\"

      """
    When I run `cucumber --strict features/transform_object_splitline.feature`
    Then the output should contain:
      """
      1 passed
      """
    And it should pass
            
