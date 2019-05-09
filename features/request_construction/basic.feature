Feature: Basic Request Construction
  A simple request with a specified method and path can be sent.

  Scenario Outline: Basic URL
    Given expected <method> sent to `/profile`

    When a <method> is sent to `/profile`
    Then expected calls are verified

  Examples:
    | method |
    | GET    |
    | POST   |
    | PATCH  |
    | DELETE |
    | PUT    |
