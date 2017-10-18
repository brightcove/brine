Feature: Adding Headers

  Backround:
    Given brine is mixed

  Scenario: Headers are added to requests.
    Given a file named "features/headers.feature" with:

      """
Feature: Request headers can be specified.
  Scenario: A new header with a single value is added to request.
    When the request header `foo` is assigned `bar`
    And a GET is sent to `/query`

    Then there was a GET request with a url matching `/query`
    And it had headers including `{"foo":"bar"}`
    And it was sent

  Scenario: Default headers are present in requests.
    When a GET is sent to `/query`

    Then there was a GET request with a url matching `/query`
    And it had headers including `{"Content-Type": "application/json"}`
    And it was sent

  Scenario: Default headers can be overridden.
    When the request header `Content-Type` is assigned `text/plain`
    And a GET is sent to `/query`

    Then there was a GET request with a url matching `/query`
    And it had headers including `{"Content-Type": "text/plain"}`
    And it was sent

  Scenario: Array header values are added to requests.
    When the request header `X-Array` is assigned `[1, 2, 3]`
    And a GET is sent to `/query`

    Then there was a GET request with a url matching `/query`
    And it had headers including `{"X-Array": "1, 2, 3"}`
    And it was sent

  Scenario: The last set value for a given header wins.
    When the request header `foo` is assigned `bar`
    And the request header `foo` is assigned `baz`
    And a GET is sent to `/query`

    Then there was a GET request with a url matching `/query`
    And it had headers including `{"foo": "baz"}`
    And it was sent

  Scenario Outline: Header is added regardless of HTTP method.
    When the request header `foo` is assigned `bar`
    And a <method> is sent to `/query`

    Then there was a <method> request with a url matching `/query`
    And it had headers including `{"foo": "bar"}`
    And it was sent

  Examples:
    | method  |
    | POST    |
    | PUT     |
    | DELETE  |
    | HEAD    |
    | OPTIONS |
      """

    When I run `cucumber features/headers.feature`
    Then the output should contain:
      """
      10 passed
      """
    And it should pass