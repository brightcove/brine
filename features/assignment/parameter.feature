Feature: A Parameter
  An identifier can be assigned the value of the provided parameter.

  Scenario: Parameter assignment.
    Given a file named "features/parameter.feature" with:
      """

Feature: Parameter Assignment.
  Scenario: Simple assignment.
    Given `foo` is assigned `bar`
    When the response body is assigned `{{ foo }}`
    Then the value of the response body is equal to `bar`

      """
    When I run `cucumber --strict features/parameter.feature`
    Then the output should contain:
      """
      1 passed
      """
    And it should pass
