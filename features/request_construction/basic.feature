Feature: Basic Request Construction
  A simple request with a specified method and path can be sent.

  Backround:
    Given brine is mixed

  Scenario Outline: Varying Methods
    Given a file named "features/basic_requests.feature" with:

      """
Feature: Sending a method
  Scenario: Basic URL
    When a <method> is sent to `/profile`
    Then there was a <method> request with a url matching `/profile`
    And it was sent
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
