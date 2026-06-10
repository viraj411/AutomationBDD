@ui
Feature: User login
  As a visitor
  I want to log in to the demo store
  So that I can access products after authentication

  Background:
    Given I am on the login page

  Scenario: Successful login with valid credentials
    When I login with username "standard_user" and password "secret_sauce"
    Then I should see the products page

  Scenario: Failed login with invalid password
    When I login with username "standard_user" and password "wrong_password"
    Then I should see login error "Epic sadface: Username and password do not match any user in this service"

  Scenario: Failed login with locked out user
    When I login with username "locked_out_user" and password "secret_sauce"
    Then I should see login error "Epic sadface: Sorry, this user has been locked out."
