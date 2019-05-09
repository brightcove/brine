Feature: All Elements
  Assertions can be done against all elements of a structure.

  Scenario: List in response body
    When the response body is assigned:
      """
      ["a", "bb", "ccc"]
      """
    Then the value of the response body has elements which are all matching `/\w+/`

  Scenario: Spread nested lists
    When the response body is assigned:
      """
      [{"val": "foo"},{"val": "foo"}]
      """
    Then the value of the response body children `..val` has elements which are all equal to `foo`
