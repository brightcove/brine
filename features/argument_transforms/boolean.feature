Feature: An argument that could represent a boolean value will be
    transformed into a boolean type.

  Background
    Given brine is mixed

  Scenario Outline: Assorted basic inputs are provided.
    Given a file named "features/transform_boolean.feature" with:
      """

Feature: Transform boolean arguments.
  Scenario: Docstring simple value.
    When the response body is assigned:
      \"\"\"
      <input>
      \"\"\"
    Then the response body as JSON is:
      \"\"\"
      '<expected>'
      \"\"\"

  Scenario: Inline simple value.
    When the response body is assigned `<input>`
    Then the response body as JSON is:
      \"\"\"
      '<expected>'
      \"\"\"

      """
    When I run `cucumber --strict features/transform_boolean.feature`
    Then the output should contain:
      """
      2 passed
      """
    And it should pass

    Examples:
      | input     | expected |
      | true      | true     |
      | false     | false    |
