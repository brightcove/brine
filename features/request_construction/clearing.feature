Feature: Cleared After Sent
  After a request is sent, any values that were added to that request
are cleared and will not be present in subsequent requests.

  Scenario: Request is Cleared Before Second Send
    Given a file named "features/request_clearing.feature" with:

      """
Feature: Clearing the request.
  Scenario: Request body is cleared.
    Given expected request body:
      \"\"\"
      {"request":1}
      \"\"\"
    And expected PUT sent to `/profile`
    Given expected request body:
      \"\"\"
      \"\"\"
    And expected PUT sent to `/store`

    When the request body is assigned:
    \"\"\"
    {"request":1}
    \"\"\"
    And a PUT is sent to `/profile`
    And a PUT is sent to `/store`

    Then expected calls are verified

  Scenario: Request parameter
    Given expected GET sent to `/query?foo=bar`
    And expected GET sent to `/resource`

    Given the request query parameter `foo` is assigned `bar`
    And a GET is sent to `/query`

    When a GET is sent to `/resource`
    Then expected calls are verified
      """

    When I run `cucumber features/request_clearing.feature`
    Then the output should contain:
      """
      2 passed
      """
    And it should pass
