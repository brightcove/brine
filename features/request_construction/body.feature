Feature: Assigning a Request Body

  Scenario: Request With Body
    Given a file named "features/request_body.feature" with:
      """
Feature: Passing a body
  Scenario: Basic URL
    Given expected request body:
    \"\"\"
    {"request":1}
    \"\"\"
    And expected PUT sent to `/store`

    When the request body is assigned:
    \"\"\"
    {"request":1}
    \"\"\"
    When a PUT is sent to `/store`
    Then expected calls are verified
      """
    When I run `cucumber features/request_body.feature`
    Then the output should contain:
      """
      5 passed
      """
    And it should pass
