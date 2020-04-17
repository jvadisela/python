package com.spg.bdd.gluecode;

import com.spg.bdd.library.Employee;
import com.spg.bdd.library.RestUtils;
import com.spg.bdd.library.TestContext;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import io.restassured.specification.RequestSpecification;

public class PayloadValidationsFeature {
	
	private RequestSpecification restSpec = null; 
	private Employee emp = null;
	
	@Given("^REST API is running$")
	public void rest_API_is_running() throws Throwable {
		System.out.println("Given...");
		TestContext ctxt = TestContext.getInstance();
		emp = (Employee) ctxt.getJson();
		System.out.println("ctxt.getJson() :: " + ctxt.getJson());
		restSpec = RestUtils.getHttpClient(ctxt.getJson());
	}

	@When("^payload has age as (\\d+)$")
	public void payload_has_age_as(int age) throws Throwable {
		System.out.println("age : " + age);
		emp.setAge(String.valueOf(age));
	}

	@When("^payload has Gender as \"([^\"]*)\"$")
	public void payload_has_Gender_as(String gender) throws Throwable {
		System.out.println("gender : " + gender);
		emp.setGender(gender);
	}

	@Then("^status code is (\\d+) but error msg is \"([^\"]*)\"$")
	public void status_code_is_but_error_msg_is(int statusCode, String errorMsg) throws Throwable {
		System.out.println();
		System.out.println("emp :: " + emp);
		System.out.println("statusCode : " + statusCode);
		System.out.println("errorMsg : " + errorMsg);
		System.out.println();
		String s = restSpec.when().get().asString();
		System.out.println(s);
	}
	
	

}
