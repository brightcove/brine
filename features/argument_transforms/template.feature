Feature: An argument that includes {{ }} interpolation markers will be
    treated as a template and transformed into an evaluated version of
    that template using the current binding environment which will then
    also be transformed.

  Backround
    Given brine is mixed

  Scenario Outline: A single value template is expanded
      using a simple bound value.
    Given a file named "features/transform_template.feature" with:
      """
Feature: Transform template arguments.
  Background:
    When `bound` is assigned `<binding>`

  Scenario: Docstring single value template.
    When the response body is assigned:
      \"\"\"
      {{{bound}}}
      \"\"\"
    Then the response body as JSON is:
      \"\"\"
      '<expected>'
      \"\"\"
  Scenario: Inline single value template.
    When the response body is assigned `{{{bound}}}`
    Then the response body as JSON is:
      \"\"\"
      '<expected>'
      \"\"\"
      """
    When I run `cucumber --strict features/transform_template.feature`
    Then the output should contain:
      """
      1 passed
      """
    And it should pass

    # Double quotes for quoted because it will be transformed on binding also
    Examples:
      | binding        | expected  |
      | true           | true      |
      | -452           | -452      |
      | ""-452""       | "-452"    |
      | ["a", 1]       | ["a",1]   |
      | ""["a", 1]""     | "[\\"a\\", 1]" |
