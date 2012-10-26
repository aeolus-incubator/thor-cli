Feature: Provider

  Scenario: List Providers
    When I run "aeocli provider list"
    Then the output should contain "Placeholder to list providers"

