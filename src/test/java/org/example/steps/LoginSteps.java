package org.example.steps;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.example.pages.LoginPage;
import org.example.support.DriverManager;
import org.example.support.TestConfig;
import org.junit.jupiter.api.Assertions;

public class LoginSteps {

    private LoginPage loginPage;

    @Given("I am on the login page")
    public void iAmOnTheLoginPage() {
        loginPage = new LoginPage(DriverManager.getDriver(), TestConfig.getBaseUrl());
        loginPage.open();
    }

    @When("I login with username {string} and password {string}")
    public void iLoginWithUsernameAndPassword(String username, String password) {
        loginPage.login(username, password);
    }

    @Then("I should see the products page")
    public void iShouldSeeTheProductsPage() {
        Assertions.assertTrue(loginPage.isProductsPageDisplayed(), "Products page was not displayed");
    }

    @Then("I should see login error {string}")
    public void iShouldSeeLoginError(String expectedError) {
        Assertions.assertEquals(expectedError, loginPage.getErrorMessage());
    }
}
