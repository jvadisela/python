package com.spg.bdd.library;

import io.restassured.specification.RequestSpecification;
import static io.restassured.RestAssured.given;

public class RestUtils {

	static String consumerKey = null;
	static String consumerSecret = null;
	static String basePath = null;
	static String baseUri = "http://dummy.restapiexample.com/api/v1/employee/4";
			
	public static RequestSpecification getHttpClient(Object json) {
		return given()
		//.auth()
		//.preemptive()
		//.basic(consumerKey, consumerSecret)
		//.basePath(basePath)
		.baseUri(baseUri);
	}
}
