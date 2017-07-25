Feature: An argument that is quoted will be (not) transformed into
    into a string, regardless of any more specific data type the
    quoted value may resemble.

  Backround
    Given brine is mixed

  Scenario Outline: Assorted basic inputs are provided.
    Given a file named "features/transform_quoted.feature" with:
      """
Feature: Transform quoted arguments.
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
    When I run `cucumber --strict features/transform_quoted.feature`
    Then the output should contain:
      """
      2 passed
      """
    And it should pass

    Examples:
      | input               | expected            |
      | "true"              | "true"              |
      | "123"               | "123"               |
      | " -123 "            | " -123 "            |
      | "["foo","bar"]"     | "[\"foo\",\"bar\"]" |
      | "{"foo":"bar"}"     | "{\"foo\":\"bar\"}" |
