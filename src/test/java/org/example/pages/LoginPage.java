package org.example.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class LoginPage {

    private static final By USERNAME = By.id("user-name");
    private static final By PASSWORD = By.id("password");
    private static final By LOGIN_BUTTON = By.id("login-button");
    private static final By INVENTORY_CONTAINER = By.id("inventory_container");
    private static final By ERROR_MESSAGE = By.cssSelector("[data-test='error']");

    private final WebDriver driver;
    private final String baseUrl;

    public LoginPage(WebDriver driver, String baseUrl) {
        this.driver = driver;
        this.baseUrl = baseUrl;
    }

    public void open() {
        driver.get(baseUrl);
    }

    public void login(String username, String password) {
        WebElement usernameField = driver.findElement(USERNAME);
        usernameField.clear();
        usernameField.sendKeys(username);

        WebElement passwordField = driver.findElement(PASSWORD);
        passwordField.clear();
        passwordField.sendKeys(password);

        driver.findElement(LOGIN_BUTTON).click();
    }

    public boolean isProductsPageDisplayed() {
        return driver.findElement(INVENTORY_CONTAINER).isDisplayed();
    }

    public String getErrorMessage() {
        return driver.findElement(ERROR_MESSAGE).getText();
    }
}
