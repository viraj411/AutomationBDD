Feature: Basic calculator
  As a BDD learner
  I want to describe math behavior in plain English
  So that I can connect Gherkin scenarios to Java code

  Scenario: Add two positive numbers
    Given I have a calculator
    When I add 2 and 3
    Then the result should be 5

  Scenario Outline: Add various numbers
    Given I have a calculator
    When I add <a> and <b>
    Then the result should be <total>

    Examples:
      | a  | b | total |
      | 1  | 1 | 2     |
      | 10 | 5 | 15    |
      | 0  | 7 | 7     |
