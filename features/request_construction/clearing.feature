Feature: Request clearing after sending
  Backround
    Given brine is mixed

  Scenario: Clearing between requests
    Given a file named "features/request_clearing.feature" with:
      """
Feature: Clearing the request
  Scenario: Basic URL
    When the request body is:
    \"\"\"
    {"request":1}
    \"\"\"
    When a PUT is sent to `www.example.com`
    And a PUT is sent to `www.brightcove.com`
    Then there was a PUT request with a url matching `www.brightcove.com`
    And it had a body not matching:
    \"\"\"
    {"request":1}
    \"\"\"
    And it was sent
      """
    When I run `cucumber features/request_clearing.feature`
    Then the output should contain:
      """
      1 passed
      """
    And it should pass
