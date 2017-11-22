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
      DEPRECATION:
      """
    And it should pass
