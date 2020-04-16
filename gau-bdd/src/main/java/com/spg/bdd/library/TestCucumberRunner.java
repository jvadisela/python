package com.spg.bdd.library;

import org.openqa.selenium.WebDriver;
import org.testng.annotations.AfterSuite;
import org.testng.annotations.BeforeSuite;

import cucumber.api.CucumberOptions;
import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.testng.AbstractTestNGCucumberTests;

@CucumberOptions(
		features = "src/test/resources/features", 
		tags = { "@SanityModule,@SmokeModule" }, 
		glue = { "com.spg.bdd.gluecode", "com.spg.bdd.library" }, 
		plugin = { "pretty:target/cucumber-reports/cucumber-pretty.txt",
				"json:target/cucumber-reports/Cucumber.json", "junit:target/cucumber-reports/Cucumber.xml",
				"html:target/cucumber-reports" }, monochrome = true, dryRun = false)
public class TestCucumberRunner extends AbstractTestNGCucumberTests {
	
	public static WebDriver driver = null;
	public static String DataFilesPath = "DataFiles";
	public static String CurrentTestCaseName = "";
	public static String moduleName = "";
	public static String CurrentFolderPath = "";
	public static String BrowserName = "";
	private JsonCacheDB jsonCacheDB = new JsonCacheDB();
	
	@BeforeSuite

	public void beforesuite() {
		System.out.println("beforesuite");
	}

	@Before
	public void beforemethod(Scenario currentscenario) {
		System.out.println("beforemethod...");
		String moduleName = null;
		String scenarioType = null;
		String scenarioName = currentscenario.getName();
		Object json = null;

		for (String tagname : currentscenario.getSourceTagNames()) {
			if (tagname.toLowerCase().contains("scenario")) {
				String annotation = tagname.replaceAll("@", "");
				String fileName = annotation.substring(annotation.indexOf("'") + 1, annotation.length() - 2);
				json = jsonCacheDB.getJson(fileName);
				scenarioType = annotation.substring(0,  annotation.indexOf("("));
			} else if (tagname.toLowerCase().contains("module")) {
				moduleName = tagname.replaceAll("@", "");
			}
		}
		
		System.out.println("moduleName	:: " + moduleName);
		System.out.println("scenarioType	:: " + scenarioType);
		System.out.println("scenarioName	:: " + scenarioName);
		System.out.println("json	:: " + json);
		
		TestContext ctx = TestContext.getInstance();
		ctx.setModuleName(moduleName);
		ctx.setScenarioName(scenarioName);
		ctx.setScenarioType(scenarioType);
		ctx.setJson(json);
	}

	@After
	public void aftermethod() {
		System.out.println("aftermethod");
	}

	@AfterSuite
	public void aftersuite() {
		System.out.println("aftersuite");
	}

	
}
