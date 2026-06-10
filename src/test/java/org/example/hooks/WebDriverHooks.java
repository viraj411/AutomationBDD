package org.example.hooks;

import io.cucumber.java.After;
import io.cucumber.java.Before;
import org.example.support.DriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import java.time.Duration;

public class WebDriverHooks {

    @Before("@ui")
    public void setUp() {
        ChromeOptions options = new ChromeOptions();
        if (System.getenv("CI") != null) {
            options.addArguments("--headless=new", "--no-sandbox", "--disable-dev-shm-usage", "--window-size=1920,1080");
        }
        WebDriver driver = new ChromeDriver(options);
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
        driver.manage().window().maximize();
        DriverManager.setDriver(driver);
    }

    @After("@ui")
    public void tearDown() {
        DriverManager.quitDriver();
    }
}
