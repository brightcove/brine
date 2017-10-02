Feature: All Elements
  Assertions can be done against all elements of a structure.

  Background
    Give brine is mixed

  Scenario: Assorted positive and negative assertions.
    Given a file named "features/all.feature" with:
      """

Feature: Allow selection of all structure elements
  Scenario: List in response body
    When the response body is assigned:
      \"\"\"
      ["a", "bb", "ccc"]
      \"\"\"
    Then the value of the response body has elements which are all matching `/\w+/`

  Scenario: Spread nested lists
    When the response body is assigned:
      \"\"\"
      [{"val": "foo"},{"val": "foo"}]
      \"\"\"
    Then the value of the response body children `..val` has elements which are all equal to `foo`

      """
    When I run `cucumber --strict features/all.feature`
    Then the output should contain:
      """
      4 passed
      """
    And it should pass

  Scenario: Failing tests since negation isn't available yet.
    Given a file named "features/all.feature" with:
      """

Feature: Allow selection of all structure elements
  Scenario: List in response body
    When the response body is assigned:
      \"\"\"
      ["a", "bb", "ccc"]
      \"\"\"
    Then the value of the response body has elements which are all matching `/^\w$/`

  Scenario: Spread nested lists
    When the response body is assigned:
      \"\"\"
      [{"val": "foo"},{"val": "fob"}]
      \"\"\"
    Then the value of the response body children `..val` has elements which are all equal to `foo`

      """
    When I run `cucumber --strict features/all.feature`
    Then the output should contain:
      """
      2 failed
      """