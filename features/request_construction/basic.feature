Feature: Basic Request Construction
  A simple request with a specified method and path can be sent.

  Scenario Outline: Varying Methods
    Given a file named "features/basic_requests.feature" with:

      """
Feature: Sending a method
  Scenario: Basic URL
    Given expected <method> sent to `/profile`

    When a <method> is sent to `/profile`
    Then expected calls are verified
      """

    When I run `cucumber features/basic_requests.feature`
    Then the output should contain:
      """
      1 passed
      """
    And it should pass

    Examples:
      | method |
      | GET    |
      | POST   |
      | PATCH  |
      | DELETE |
      | PUT    |
