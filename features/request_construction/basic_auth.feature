Feature: Adding Basic Auth

  Scenario: A new header with expected value is added to request.
    Given expected request headers:
      """
      {"Authorization":"Basic dXNlcjpwYXNz"}
      """
    And expected GET sent to `/query`

    When the request credentials are set for basic auth user `user` and password `pass`
    And a GET is sent to `/query`

    Then expected calls are verified
