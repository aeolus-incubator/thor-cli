Feature: Exception Handling

  Scenario: Garbage URL Input
    When I run `aeolus provider list --conductor-url=http://444.444.444.444:444/api --username=test --password=test`
    Then the aeolus command should write the stack trace to file
    And the output should contain:
    """
    Error:
    """
    And the exit status should be 1
