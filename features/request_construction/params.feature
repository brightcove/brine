Feature: Adding Query Parameters

  Scenario: Query parameters are added to requests.
    Given a file named "features/params.feature" with:

      """
Feature: Request query parameters can be specified.
  Scenario: A single parameter is appended to the URL.
    When the request query parameter `foo` is assigned `bar`
    And a GET is sent to `/query`

    Then there was a GET request with a url matching `/query\?foo=bar`
    And it was sent

  Scenario: Multiple parameters are appended to the URL with proper formatting.
    When the request query parameter `foo` is assigned `bar`
    And the request query parameter `baz` is assigned `1`
    And a GET is sent to `/query`

    Then there was a GET request sent with a url matching `/query\?\w+=\w+&\w+=\w+`
    And there was a GET request sent with a url matching `foo=bar`
    And there was a GET request sent with a url matching `baz=1`

  Scenario Outline: Values are encoded appropriately.
    When the request query parameter `foo` is assigned `<input>`
    And a GET is sent to `/query`

    Then there was a GET request sent with a url matching `foo=<encoded>`
  Examples:
    | input         | encoded                  |
    # Crazy escaping to keep the `+` escaped for the regex
    | bar & grill   | bar\\\\+%26\\\\+grill    |
    | + +           | %2B\\\\+%2B              |
    | (imbalance))  | %28imbalance%29%29       |

  Scenario Outline: Parametes are added regardless of HTTP method.
    When the request query parameter `foo` is assigned `bar`
    And a <method> is sent to `/query`

    Then there was a <method> request sent with a url matching `foo=bar`
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