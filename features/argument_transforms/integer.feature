Feature: An argument that could represent an integer will be
    transformed into an integer type.

  Scenario Outline: Assorted basic inputs are provided.
    Given a file named "features/transform_integer.feature" with:
      """

Feature: Transform integer arguments.
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
    When I run `cucumber --strict features/transform_integer.feature`
    Then the output should contain:
      """ar
      2 passed
      """
    And it should pass

    Examples:
      |               input |            expected |
      |                   0 |                   0 |
      |                  -0 |                   0 |
      |                  10 |                  10 |
      |                 -10 |                 -10 |
      |  123456789123456789 |  123456789123456789 |
      | -123456789123456789 | -123456789123456789 |
