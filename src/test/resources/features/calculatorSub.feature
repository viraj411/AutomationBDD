Feature: Basic calculator
  As a BDD learner
  I want to describe math behavior in plain English
  So that I can connect Gherkin scenarios to Java code

  Scenario: Subtract two positive numbers
    Given I have a calculator
    When I subtract 6 and 3
    Then the result should be 3

  Scenario Outline: Subtract various numbers
    Given I have a calculator
    When I subtract <a> and <b>
    Then the result should be <total>
  Examples:
      | a  | b | total|
      | 54 | 44| 10 |
      | 10 | 5 | 5  |
      | 7  | 7 | 0  |