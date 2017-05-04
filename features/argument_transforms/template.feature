@wip
Feature: Template expansion
  Backround
    Given brine is mixed

  Scenario Outline: Simple
    Given a file named "features/single.feature" with:
      """
Feature: Simple Template Expasion
  Scenario: passing array
    When `bound` is bound to `<binding>`
    When the response body is:
    \"\"\"
    {"val": {{{bound}}}}
    \"\"\"
    Then the response body as JSON is:
    \"\"\"
    '{"val":<expected>}'
    \"\"\"
      """
    When I run `cucumber features/single.feature`
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
      | ""[\"a\", 1]"" | "[\\"a\\", 1]" |
