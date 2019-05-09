Feature: A Random String
  An identifier can be assigned a random string with decent entropy.

  Scenario: Several unique variables.
    Given `v1` is assigned a random string
    And `v2` is assigned a random string
    And `v3` is assigned a random string
    When the response body is assigned `[ "{{ v1 }}","{{ v2 }}","{{ v3 }}" ]`
    Then the value of the response body does not have any element that is empty
    And the value of the response body child `.[0]` is equal to `{{ v1 }}`
    And the value of the response body children `.[1:2]` does not have any element that is equal to `{{ v1 }}`
    And the value of the response body child `.[2]` is not equal to `{{ v2 }}`
