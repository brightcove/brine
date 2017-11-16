Feature: Resource Cleanup
  Resources created during testing can be marked for deletion.

  Background:
    Given I set the environment variable "BRINE_LOG_HTTP" to "debug"

  Scenario: Assorted Responses
    Given a file named "features/cleanup.feature" with:

      """
Feature: Resource Cleanup

  Scenario: Successful Basic Deletion
    When a resource is created at `/some/path`
      """

    And I run `cucumber features/cleanup.feature`
    Then the output should match %r<delete http://www.example.com/some/path>
    And it should pass    