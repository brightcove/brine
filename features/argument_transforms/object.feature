Feature: JSON Object Step Argument Transform
  Backround
    Given brine is mixed

  Scenario Outline: Assorted Inputs
    Given a file named "features/object_transform.feature" with:
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
    When I run `cucumber features/object_transform.feature`
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
