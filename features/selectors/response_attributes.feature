Feature: A value from a response attribute can be selected.
  A response attribute can be selected for assertion.

  Scenario: Assorted response attribute selections.
    Given a file named "features/selectors/response_attribute.feature" with:
      """

Feature: Response Attribute Selectors.
  Scenario: Response body.
    When the response body is assigned `Some string`
    Then the value of the response body is equal to `Some string`

  Scenario: Response status.
    When the response body is assigned `Default stub status is 200`
    Then the value of the response status is equal to `200`

  Scenario: Response headers.
    When the response headers is assigned `{"test": "bar"}`
    Then the value of the response headers is equal to:
      \"\"\"
      {"test":"bar"}
      \"\"\"

  Scenario: Response header child.
    When the response headers is assigned `{"test": "bar"}`
    Then the value of the response headers child `test` is equal to `bar`

      """
    When I run `cucumber --strict features/selectors/response_attribute.feature`
    Then  the output should contain:
      """
      4 passed
      """
    And it should pass
