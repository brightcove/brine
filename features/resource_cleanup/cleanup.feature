@171
Feature: Resource Cleanup
  Resources created during testing can be marked for deletion.

  Scenario: Successful Basic Deletion
    Given expected DELETE sent to `/some/path`

    When a resource is created at `/some/path`

  Scenario: Returned 4xx
    Given expected response status of `409`
    And expected DELETE sent to `/some/path`

    When a resource is created at `/some/path`

  Scenario: Success Upon Retry
    Given expected response status sequence of `[504, 200]`
    And expected DELETE sent to `/some/path`

    When a resource is created at `/some/path`

  Scenario: Unreached Success
    Given expected response status sequence of `[504, 504, 504, 200]`
    And expected DELETE sent to `/some/path`

    When a resource is created at `/some/path`
