Feature: It can be asserted that a value is a valid instance of a type.

  Background
    Given brine is mixed

  Scenario: Positive and negative assertions for JSON types.
    Given a file named "features/is_a_valid.feature" with:
      """

Feature: Assert type validity
  Scenario: String in response bodyis only a valid String.
    When the response body is assigned:
      \"\"\"
      foo
      \"\"\"
    Then the value of the response body is a valid `String`
    And the value of the response body is not a valid `Number`
    And the value of the response body is not a valid `Object`
    And the value of the response body is not a valid `Array`
    And the value of the response body is not a valid `Boolean`

  Scenario: Number in response body is only a valid Number.
    When the response body is assigned:
      \"\"\"
      1
      \"\"\"
    Then the value of the response body is not a valid `String`
    And the value of the response body is a valid `Number`
    And the value of the response body is not a valid `Object`
    And the value of the response body is not a valid `Array`
    And the value of the response body is not a valid `Boolean`

  Scenario: Quoted Number in response body is only a valid String.
    When the response body is assigned:
      \"\"\"
      "1"
      \"\"\"
    Then the value of the response body is a valid `String`
    And the value of the response body is not a valid `Number`
    And the value of the response body is not a valid `Object`
    And the value of the response body is not a valid `Array`
    And the value of the response body is not a valid `Boolean`

  Scenario: Empty Object in response body is only a valid Object.
    When the response body is assigned:
      \"\"\"
      {}
      \"\"\"
    Then the value of the response body is not a valid `String`
    And the value of the response body is not a valid `Number`
    And the value of the response body is a valid `Object`
    And the value of the response body is not a valid `Array`
    And the value of the response body is not a valid `Boolean`

  Scenario: Object in response body is only a valid Object.
    When the response body is assigned:
      \"\"\"
      {"foo": 1}
      \"\"\"
    Then the value of the response body is not a valid `String`
    And the value of the response body is not a valid `Number`
    And the value of the response body is a valid `Object`
    And the value of the response body is not a valid `Array`
    And the value of the response body is not a valid `Boolean`

  Scenario: Quoted Object in response body is only a valid String.
    When the response body is assigned:
      \"\"\"
      "{"foo": 1}"
      \"\"\"
    Then the value of the response body is a valid `String`
    And the value of the response body is not a valid `Number`
    And the value of the response body is not a valid `Object`
    And the value of the response body is not a valid `Array`
    And the value of the response body is not a valid `Boolean`


  Scenario: Empty Array in response body is only a valid Array.
    When the response body is assigned:
      \"\"\"
      []
      \"\"\"
    Then the value of the response body is not a valid `String`
    And the value of the response body is not a valid `Number`
    And the value of the response body is not a valid `Object`
    And the value of the response body is a valid `Array`
    And the value of the response body is not a valid `Boolean`

  Scenario: Array in response body is only a valid Array.
    When the response body is assigned:
      \"\"\"
      [1, "foo"]
      \"\"\"
    Then the value of the response body is not a valid `String`
    And the value of the response body is not a valid `Number`
    And the value of the response body is not a valid `Object`
    And the value of the response body is a valid `Array`
    And the value of the response body is not a valid `Boolean`

  Scenario: true in response body is only a valid Boolean.
    When the response body is assigned:
      \"\"\"
      true
      \"\"\"
    Then the value of the response body is not a valid `String`
    And the value of the response body is not a valid `Number`
    And the value of the response body is not a valid `Object`
    And the value of the response body is not a valid `Array`
    And the value of the response body is a valid `Boolean`

  Scenario: false in response body is only a valid Boolean.
    When the response body is assigned:
      \"\"\"
      false
      \"\"\"
    Then the value of the response body is not a valid `String`
    And the value of the response body is not a valid `Number`
    And the value of the response body is not a valid `Object`
    And the value of the response body is not a valid `Array`
    And the value of the response body is a valid `Boolean`

  Scenario: null in response body is not any valid type.
    When the response body is assigned:
      \"\"\"
      [null]
      \"\"\"
    Then the value of the response body child `0` is not a valid `String`
    And the value of the response body child `0` is not a valid `Number`
    And the value of the response body child `0` is not a valid `Object`
    And the value of the response body child `0` is not a valid `Array`
    And the value of the response body child `0` is not a valid `Boolean`

      """
    When I run `cucumber --strict features/is_a_valid.feature`
    Then the output should contain:
      """
      11 passed
      """
    And it should pass
