Feature: Adding Query Parameters

  Scenario: Query parameters are added to requests.
    Given a file named "features/params.feature" with:

      """
Feature: Request query parameters can be specified.
  Scenario: A single parameter is appended to the URL.
    Given expected GET sent to `/query?foo=bar`

    When the request query parameter `foo` is assigned `bar`
    And a GET is sent to `/query`

    Then expected calls are verified

  Scenario: Multiple parameters are appended to the URL with proper formatting.
    Given expected GET sent to `/query?foo=bar&baz=1`

    When the request query parameter `foo` is assigned `bar`
    And the request query parameter `baz` is assigned `1`
    And a GET is sent to `/query`

    Then expected calls are verified

  Scenario Outline: Values are encoded appropriately.
    Given expected GET sent to `/query?foo=<encoded>`

    When the request query parameter `foo` is assigned `<input>`
    And a GET is sent to `/query`

    Then expected calls are verified
  Examples:
    | input         | encoded                  |
    | bar & grill   | bar+%26+grill            |
    | + +           | %2B+%2B                  |
    | (imbalance))  | %28imbalance%29%29       |

  Scenario Outline: Parametes are added regardless of HTTP method.
    Given expected <method> sent to `/query?foo=bar`

    When the request query parameter `foo` is assigned `bar`
    And a <method> is sent to `/query`

    Then expected calls are verified
  Examples:
    | method  |
    | POST    |
    | PUT     |
    | DELETE  |
    | HEAD    |
    | OPTIONS |
      """

    When I run `cucumber features/params.feature`
    Then the output should contain:
      """
      10 passed
      """
    And it should pass