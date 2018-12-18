Feature: Resource Cleanup
  Resources created during testing can be marked for deletion.

  Scenario: Initial Success
    Given a file named "features/cleanup.feature" with:

      """
Feature: Resource Cleanup

  Scenario: Successful Basic Deletion
    Given expected DELETE sent to `/some/path`

    When a resource is created at `/some/path`
      """

    When I run `cucumber --strict features/cleanup.feature`
    Then the output should match %r<(?i:delete) http://www.example.com/some/path>
    And the output should not contain:
      """
      ERROR
      """
    And it should pass

  Scenario: Returned 4xx
    Given a file named "features/cleanup_failure.feature" with:

      """
Feature: Resource Cleanup

  Scenario: Failed Deletion
    Given expected response status of `409`
    And expected DELETE sent to `/some/path`

    When a resource is created at `/some/path`
      """

    When I run `cucumber --strict features/cleanup_failure.feature`
    Then the output should match %r<(?:.*(?i:delete) http://www.example.com/some/path.*){3}>
    And the output should contain:
      """
      ERROR
      """
    And it should pass

  Scenario: Success Upon Retry
    Given a file named "features/cleanup_retried.feature" with:

      """
Feature: Resource Cleanup

  Scenario: Success Upon Retry
    Given expected response status sequence of `[504, 200]`
    And expected DELETE sent to `/some/path`

    When a resource is created at `/some/path`
      """

    When I run `cucumber --strict -o ../../out.log features/cleanup_retried.feature`
    Then the output should match %r<(?:.*(?i:delete) http://www.example.com/some/path.*){2}>
    And the output should not contain:
      """
      ERROR
      """
    And it should pass


  Scenario: Unreached Success
    Given a file named "features/cleanup_unreached.feature" with:

      """
Feature: Resource Cleanup

  Scenario: Unreached Success
    Given expected response status sequence of `[504, 504, 504, 200]`
    And expected DELETE sent to `/some/path`

    When a resource is created at `/some/path`
      """

    When I run `cucumber --strict -o ../../out.log features/cleanup_unreached.feature`
    Then the output should match %r<(?:.*(?i:delete) http://www.example.com/some/path.*){3}>
    And the output should contain:
      """
      ERROR
      """
    And it should pass
