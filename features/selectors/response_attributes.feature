Feature: Response Attribute
  A response attribute can be selected for assertion.

  Scenario: Response body.
    When the response body is assigned `Some string`
    Then the value of the response body is equal to `Some string`

  Scenario: Response status.
    When the response body is assigned `Default stub status is 200`
    Then the value of the response status is equal to `200`

  Scenario: Response headers.
    When the response headers is assigned `{"test": "bar"}`
    Then the value of the response headers is equal to:
      """
      {"test":"bar"}
      """

  Scenario: Response header child.
    When the response headers is assigned `{"test": "bar"}`
    Then the value of the response headers child `test` is equal to `bar`
