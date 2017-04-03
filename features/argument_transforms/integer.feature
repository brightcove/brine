Feature: Integer Argument Step Transform
  Backround
    Given brine is mixed

  Scenario Outline: assorted formats
    Given a file named "features/integer_step.feature" with:
      """
Feature: Using an integer argument
  Scenario: passing Integer
    When the response body contains the object:
      | val | <input>      |
    Then the raw response body is:
    \"\"\"
    {"val":<expected>}
    \"\"\"
      """
    When I run `cucumber features/integer_step.feature`
    Then the output should contain:
      """
      2 passed
      """
    And it should pass

    Examples:
      |         input                    |       expected      |
      |            10                    |                  10 |
      |           -10                    |                 -10 |
      |  	      10                 |                  10 |
      |    -10 		                 |                 -10 |
      | 123456789123456789               |  123456789123456789 |
      | 	-123456789123456789	 | -123456789123456789 |
