Feature: An argument that includes leading or trailing whitespace
    will be transformed so that such whitespace is removed
    and that value will also be transformed.

  Backround
    Given brine is mixed

  Scenario Outline: Assorted basic inputs are provided.
    Given a file named "features/transform_whitespace.feature" with:
      """

Feature: Transform arguments with leading and/or trailing whitespace.
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

  Scenario: Docstring value with a leading and trailing line.
    When the response body is assigned:
    \"\"\"

    <input>

    \"\"\"
    Then the response body as JSON is:
    \"\"\"
    '<expected>'
    \"\"\"

      """
    When I run `cucumber --strict features/transform_whitespace.feature`
    Then the output should contain:
      """
      3 passed
      """
    And it should pass

    Examples:
      | input                     | expected     |
      | 	true              | true         |
      |   123	                  | 123          |
      |  ["a"]	                  | ["a"]        |
