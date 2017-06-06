Feature: Template Expansion Step Argument Transform
  Backround
    Given brine is mixed

  Scenario Outline: Assorted Inputs
    Given a file named "features/template_transform.feature" with:
      """
Feature: Simple Template Expasion
  Scenario: passing array
    When `bound` is assigned `<binding>`
    When the response body is assigned:
    \"\"\"
    {{{bound}}}
    \"\"\"
    Then the response body as JSON is:
    \"\"\"
    '<expected>'
    \"\"\"
      """
    When I run `cucumber features/template_transform.feature`
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
