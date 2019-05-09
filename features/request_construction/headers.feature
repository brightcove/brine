Feature: Adding Headers

  Scenario: A new header with a single value is added to request.
    Given expected request headers:
      """
      {"foo":"bar"}
      """
    And expected GET sent to `/query`

    When the request header `foo` is assigned `bar`
    And a GET is sent to `/query`

    Then expected calls are verified

  Scenario: Default headers are present in requests.
    Given expected request headers:
      """
      {"Content-Type": "application/json"}
      """
    And expected GET sent to `/query`

    When a GET is sent to `/query`

    Then expected calls are verified

  Scenario: Default headers can be overridden.
    Given expected request headers:
      """
      {"Content-Type": "text/plain"}
      """
    And expected GET sent to `/query`    

    When the request header `Content-Type` is assigned `text/plain`
    And a GET is sent to `/query`

    Then expected calls are verified

  Scenario: Array header values are added to requests.
    Given expected request headers:
      """
      {"X-Array": "1, 2, 3"}
      """
    And expected GET sent to `/query`

    When the request header `X-Array` is assigned `[1, 2, 3]`
    And a GET is sent to `/query`

    Then expected calls are verified

  Scenario: The last set value for a given header wins.
    Given expected request headers:
      """
      {"foo":"baz"}
      """
    And expected GET sent to `/query`

    When the request header `foo` is assigned `bar`
    And the request header `foo` is assigned `baz`
    And a GET is sent to `/query`

    Then expected calls are verified

  Scenario Outline: Header is added regardless of HTTP method.
    Given expected request headers:
      """
      {"foo":"bar"}
      """
    And expected <method> sent to `/query`

    When the request header `foo` is assigned `bar`
    And a <method> is sent to `/query`

    Then expected calls are verified

  Examples:
    | method  |
    | POST    |
    | PUT     |
    | DELETE  |
    | HEAD    |
    | OPTIONS |
