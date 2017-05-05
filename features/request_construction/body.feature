Feature: Adding a body to a request
  Backround
    Given brine is mixed

  Scenario: Adding body to request
    Given a file named "features/request_body.feature" with:
      """
Feature: Passing a body
  Scenario: Basic URL
    When the request body is:
    \"\"\"
    {"request":1}
    \"\"\"
    When a PUT is sent to `www.example.com`
    Then there was a PUT request with a url matching `www.example.com`
    And it had a body matching:
    \"\"\"
    {"request":1}
    \"\"\"
    And it was sent
      """
    When I run `cucumber features/request_body.feature`
    Then the output should contain:
      """
      1 passed
      """
    And it should pass
