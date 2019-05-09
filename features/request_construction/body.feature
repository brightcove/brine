Feature: Assigning a Request Body

  Scenario: Basic URL
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
