Feature: A value from a response attribute can be assigned.
  An identifier can be assigned a value extracted from a response attribute.

  Scenario: Assorted response attribute assignments.
    Given a file named "features/assignment/response_attribute.feature" with:
      """

Feature: Reponse Attribute Path Assignment.
  Scenario: Response body.
    Given the response body is assigned `foo`
    When `myVar` is assigned the response body
    And the response body is assigned `{{ myVar }}`
    Then the value of the response body is equal to `foo`

  Scenario: Response body child.
    Given the response body is assigned `{"response": "foo"}`
    When `myVar` is assigned the response body child `.response`
    And the response body is assigned `{{ myVar }}`
    Then the value of the response body is equal to `foo`

  Scenario: Response body children.
    Given the response body is assigned `{"response": "foo"}`
    When `myVar` is assigned the response body children `.response`
    And the response body is assigned `{{{ myVar }}}`
    Then the value of the response body is equal to `["foo"]`

  Scenario: Response header.
    Given the response headers is assigned `{"test": "val"}`
    When `myVar` is assigned the response headers child `test`
    And the response body is assigned `{{ myVar }}`
    Then the value of the response body is equal to `val`

      """
    When I run `cucumber --strict features/assignment/response_attribute.feature`
    Then the output should contain:
      """
      4 passed
      """
    And it should pass
