package org.example.steps;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.example.calculator.Calculator;

import org.junit.jupiter.api.Assertions;

public class CalculatorSteps {

    private Calculator calculator;
    private int result;

    @Given("I have a calculator")
    public void iHaveACalculator() {
        calculator = new Calculator();
    }

    @When("I add {int} and {int}")
    public void iAdd(int a, int b) {
        result = calculator.add(a, b);
    }

    @Then("the result should be {int}")
    public void theResultShouldBe(int expected) {
        Assertions.assertEquals(expected, result);
    }


    @When("I subtract {int} and {int}")
    public void iSubtract(int a, int b) {
        result = calculator.subtract(a, b);
    }
    @Then("the result should be subtracted {int}")
    public void theResultShouldBeSubtract(int expected) {
        Assertions.assertEquals(expected, result);
    }
}
