Feature: JSON Object Step Argument Transform
  Backround
    Given brine is mixed

  Scenario Outline: Assorted Inputs
    Given a file named "features/object_transform.feature" with:
      """
Feature: Using an object argument
  Scenario: Single line objects
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
            
  Scenario: Object split over multiple lines
    Given a file named "features/object_splitline_transform.feature" with:
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
    When I run `cucumber features/object_splitline_transform.feature`
    Then the output should contain:
      """
      1 passed
      """
    And it should pass
            
