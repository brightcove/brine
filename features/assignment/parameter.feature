Feature: A Parameter
  An identifier can be assigned the value of the provided parameter.

  Scenario: Simple assignment.
    Given `foo` is assigned `bar`
    When the response body is assigned `{{ foo }}`
    Then the value of the response body is equal to `bar`
