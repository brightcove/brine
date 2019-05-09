Feature: A Timestamp
  An identifier can be assigned a current timestamp.

  Scenario: Newer than some old date.
    Given `v1` is assigned a timestamp
    When the response body is assigned `{{ v1 }}`
    Then the value of the response body is greater than `2018-06-17T12:00:00Z`

  Scenario: Values increase.
    Given `v1` is assigned a timestamp
    When the response body is assigned `{{ v1 }}`
    Then the value of the response body is not empty

    When `v2` is assigned a timestamp
    And the response body is assigned `{{ v2 }}`
    Then the value of the response body is greater than or equal to `{{ v1 }}`

    When `v3` is assigned a timestamp
    And the response body is assigned `{{ v3 }}`
    Then the value of the response body is greater than or equal to `{{ v1 }}`
    And the value of the response body is greater than or equal to `{{ v2 }}`
