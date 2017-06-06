Feature: Boolean Step Argument Transform
  Background
    Given brine is mixed

  Scenario Outline: Assorted Inputs
    Given a file named "features/boolean_transform.feature" with:
    """
Feature: Using a boolean argument
  Scenario: passing Boolean
    When the response body is assigned:
    \"\"\"
    <input>
    \"\"\"
    Then the response body as JSON is:
    \"\"\"
    '<expected>'
    \"\"\"
      """
    When I run `cucumber features/boolean_transform.feature`
    Then the output should contain:
      """
      2 passed
      """
    And it should pass

    Examples:
      | input     | expected |
      | true      | true     |
      | false     | false    |
