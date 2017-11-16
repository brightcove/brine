Feature: A valid ...

  Scenario: Positive and negative assertions for JSON types.
    Given a file named "features/is_a_valid.feature" with:
      """

Feature: Assert type validity
  Scenario: String in response body is only a valid String.
    When the response body is assigned:
      \"\"\"
      foo
      \"\"\"
    Then the value of the response body is a valid `String`
    And the value of the response body is not a valid `Number`
    And the value of the response body is not a valid `Integer`
    And the value of the response body is not a valid `Object`
    And the value of the response body is not a valid `Array`
    And the value of the response body is not a valid `Boolean`

  Scenario: Integer in response body is a valid Integer and Number.
    When the response body is assigned:
      \"\"\"
      1
      \"\"\"
    Then the value of the response body is not a valid `String`
    And the value of the response body is a valid `Number`
    And the value of the response body is a valid `Integer`
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
    And the value of the response body is not a valid `Integer`
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
    And the value of the response body is not a valid `Integer`
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
    And the value of the response body is not a valid `Integer`
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
    And the value of the response body is not a valid `Integer`
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
    And the value of the response body is not a valid `Integer`
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
    And the value of the response body is not a valid `Integer`
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
    And the value of the response body is not a valid `Integer`
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
    And the value of the response body is not a valid `Integer`
    And the value of the response body is not a valid `Object`
    And the value of the response body is not a valid `Array`
    And the value of the response body is a valid `Boolean`

  Scenario: null in response body is not any valid type.
    When the response body is assigned:
      \"\"\"
      [null]
      \"\"\"
    Then the value of the response body child `[0]` is not a valid `String`
    And the value of the response body child `[0]` is not a valid `Number`
    And the value of the response body child `[0]` is not a valid `Integer`
    And the value of the response body child `[0]` is not a valid `Object`
    And the value of the response body child `[0]` is not a valid `Array`
    And the value of the response body child `[0]` is not a valid `Boolean`

  Scenario: Selected Array child is a valid Array.
    When the response body is assigned:
      \"\"\"
      {"val": [1, 2, 3]}
      \"\"\"
    Then the value of the response body child `val` is a valid `Array`

  Scenario: Selected Array child member is a valid String.
    When the response body is assigned:
      \"\"\"
      {"val": [1, 2, 3]}
      \"\"\"
    Then the value of the response body child `val[0]` is a valid `Number`
    Then the value of the response body child `val[0]` is a valid `Integer`

  Scenario: Selected nested children are a valid Array.
    When the response body is assigned:
      \"\"\"
      [{"val": 1},{"val": 2}]
      \"\"\"
    Then the value of the response body children `.val` is a valid `Array`

  Scenario: Selected nested children can be tested for type.
    When the response body is assigned:
      \"\"\"
      [{"val": 1},{"val": 2}]
      \"\"\"
    Then the value of the response body children `.val` has elements which are all a valid `Number`
    Then the value of the response body children `.val` has elements which are all a valid `Integer`

  Scenario: Selected nested children can be tested for type when Arrays.
    When the response body is assigned:
      \"\"\"
      [{"val": [1]},{"val": [2]}]
      \"\"\"
    Then the value of the response body children `.val` has elements which are all a valid `Array`

      """
    When I run `cucumber --strict features/is_a_valid.feature`
    Then the output should contain:
      """
      16 passed
      """
    And it should pass
