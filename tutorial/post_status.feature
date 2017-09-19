Feature: A POST returns a 201.

  Scenario: A valid post.
    When the request body is assigned:
      """
      {"name": "boolean-setting",
       "value": true}
      """
    And a POST is sent to `/bins`
    Then the value of the response status is equal to `201`