Feature: Cleared After Sent
  After a request is sent, any values that were added to that request
are cleared and will not be present in subsequent requests.

  Scenario: Request is Cleared Before Second Send
    Given a file named "features/request_clearing.feature" with:

      """
Feature: Clearing the request.
  Scenario: Request body is cleared.
    Given the request body is assigned:
    \"\"\"
    {"request":1}
    \"\"\"
    And a PUT is sent to `/profile`

    When a PUT is sent to `/store`
    Then there was a PUT request with a url matching `/store`
    And it had a body not matching:
    \"\"\"
    {"request":1}
    \"\"\"
    And it was sent

  Scenario: Request parameter
    Given the request query parameter `foo` is assigned `bar`
    And a GET is sent to `/query`

    When a GET is sent to `/resource`
    Then there was a GET request sent with a url matching `/resource$`
      """

    When I run `cucumber features/request_clearing.feature`
    Then the output should contain:
      """
      2 passed
      """
    And it should pass
