Feature: Assigning a Request Body

  Scenario: Attach a basic body.
    Given expected request body:
      """
      {"request":1}
      """
    And expected PUT sent to `/store`

    When the request body is assigned:
      """
      {"request":1}
      """
    When a PUT is sent to `/store`
    Then expected calls are verified

  Scenario: Attach a template body.
    Given expected request body:
      """
      {"request":"foo"}
      """
    And expected PUT sent to `/store`

    Given `val` is assigned `foo`
    When the request body is assigned:
      """
      {"request":"{{val}}"}
      """
    When a PUT is sent to `/store`
    Then expected calls are verified
