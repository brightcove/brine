Feature: Absent resources return 404s.

  Scenario: A request for a known missing resource.
    When a GET is sent to `/bins/brine-absent`
    Then the value of the response status is equal to `404`