Feature: A POST returns a link to the created resource.

  Scenario: A valid post.
    When the request body is assigned:
      """
      {"name": "boolean-setting",
       "value": true}
      """
    And a POST is sent to `/bins`

    Then the value of the response status is equal to `201`
    And the value of the response body child `uri` is matching `/https://api.myjson.com/bins/\w+/`