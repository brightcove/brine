@169
Feature: Regular Expression
  An argument that is enclosed in slashes (/) will be transformed into a regex.

  Scenario Outline: Docstring simple value.
    When the response body is assigned:
      """
      <input>
      """
    Then the response body as JSON is:
      """
      <expected>
      """

  #Expecting Ruby stringification and using painful escaping
  Examples:
    | input             | expected                                            |
    | //                | "(?-mix:)"                                          |
    | /\//              | "(?-mix:\\\\\\/)"                                   |
    | /.*/              | "(?-mix:.*)"                                        |
    | /"[[:alpha:]]?"/  | "(?-mix:\\"[[:alpha:]]?\\")"                        |
    | /foo bar/         | "(?-mix:foo bar)"                                   |

  Scenario Outline: Inline simple value.
    When the response body is assigned `<input>`
    Then the response body as JSON is:
      """
      <expected>
      """

  #Expecting Ruby stringification and using painful escaping
  Examples:
    | input             | expected                                            |
    | //                | "(?-mix:)"                                          |
    | /\//              | "(?-mix:\\\\\\/)"                                   |
    | /.*/              | "(?-mix:.*)"                                        |
    | /"[[:alpha:]]?"/  | "(?-mix:\\"[[:alpha:]]?\\")"                        |
    | /foo bar/         | "(?-mix:foo bar)"                                   |
