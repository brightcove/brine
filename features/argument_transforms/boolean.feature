Feature: Boolean Argument Step Transform
  Background
    Given brine is mixed

  Scenario Outline: assorted formats
    Given a file named "features/boolean_step.feature" with:
    """
Feature: Using a boolean argument
  Scenario: passing Boolean
    When the response body contains the object:
      | val | <input> |
    Then the raw response body is:
    \"\"\"
    {"val":<expected>}
    \"\"\"
      """
    When I run `cucumber features/boolean_step.feature`
    Then the output should contain:
      """
      2 passed
      """
    And it should pass

    Examples:
      | input     | expected |
      | true      | true     |
      | false     | false    |
      | true	  | true     |
      |	false     | false    |
