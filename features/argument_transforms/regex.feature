Feature: An argument that is enclosed in slashes (/) will be transformed into a regex.

  Scenario Outline: Assorted basic inputs are provided.
    Given a file named "features/transform_regex.feature" with:
      """

Feature: Tranform regex arguments.
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
    When I run `cucumber --strict features/transform_regex.feature`
    Then the output should contain:
      """
      2 passed
      """
    And it should pass

    #Expecting Ruby stringification and using painful escaping
    Examples:
      | input             | expected                                            |
      | //                | "(?-mix:)"                                          |
      | /\//              | "(?-mix:\\\\\\\\/)"                                 |
      | /.*/              | "(?-mix:.*)"                                        |
      | /"[[:alpha:]]?"/  | "(?-mix:\\\\"[[:alpha:]]?\\\\")"                    |
      | /foo bar/         | "(?-mix:foo bar)"                                   |