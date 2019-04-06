Feature: Deprecation Messaging

  Scenario: Deprecation Message is Displayed
    Given a file named "features/deprecation.feature" with:
    """
Feature: Deprecation Messaging
  Scenario: Multine String
    When the response body is:
      \"\"\"
      Anything
      \"\"\"
    Then the response body as JSON is:
      \"\"\"
      ""Anything""
      \"\"\"
  Scenario: Multine Object
    When the response body is:
      \"\"\"
      {"isObj": true}
      \"\"\"
    Then the response body as JSON is:
      \"\"\"
      '{"isObj":true}'
      \"\"\"
      """
    When I run `cucumber features/deprecation.feature`
    Then the output should contain:
      """
      2 passed
      """
    And the output should contain:
      """
      DEPRECATION
      """
    And it should pass

  Scenario: 0.9 depprecations
    Given a file named "features/0.9.feature" with:
      """

Feature: 0.9
  Scenario: includes the entries
    When the response body is assigned `{"foo":"bar"}`
    Then the response body includes the entries:
      | foo | bar |

      """
    When I run `cucumber --strict features/0.9.feature`
    Then the output should contain:
      """
      1 passed
      """
    And it should pass

