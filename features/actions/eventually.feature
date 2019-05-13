Feature: Eventually
  Conditions which are eventually but may not be immediately satisfied can be tested.

  Scenario: A delayed response fails a basic test.
    When the response is delayed `1` seconds
    And the response body is assigned:
      """
      {"completed": true}
      """

    Then the value of the response body is not equal to:
      """
      {"completed": true}
      """

  Scenario: A delayed response passes an eventual test.
    When the response is delayed `2` seconds
    And the response body is assigned:
      """
      {"completed": true}
      """

    Given actions are defined such that
      Then the value of the response body is equal to:
        """
        {"completed": true}
        """
    Then the actions are successful within a `short` period

  Scenario: A late response fails an eventual test.
    When the response is delayed `5` seconds
    And the response body is assigned:
      """
      {"completed": true}
      """

    Given actions are defined such that
      Then the value of the response body is equal to:
        """
        {"completed": true}
        """
    Then the actions are not successful within a `short` period

  Scenario: A late response passes a patient eventual test.
    When the response is delayed `5` seconds
    And the response body is assigned:
      """
      {"completed": true}
      """

    Given actions are defined such that
      Then the value of the response body is equal to:
        """
        {"completed": true}
        """
    Then the actions are successful within a `long` period
