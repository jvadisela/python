package com.spg.bdd.library;

/**
 * Test Context to hold the ModuleName, ScenarioName & JSON
 * 
 * @author jvadisela
 *
 */
public class TestContext {

	private static TestContext ctxObj = new TestContext();

	private String moduleName;
	private String scenarioType;
	private String scenarioName;
	private Object json;

	private TestContext() {

	}

	public static TestContext getInstance() {
		return ctxObj;
	}

	public String getModuleName() {
		return moduleName;
	}

	public void setModuleName(String moduleName) {
		this.moduleName = moduleName;
	}

	public String getScenarioName() {
		return scenarioName;
	}

	public void setScenarioName(String scenarioName) {
		this.scenarioName = scenarioName;
	}

	public Object getJson() {
		return json;
	}

	public void setJson(Object json) {
		this.json = json;
	}

	public String getScenarioType() {
		return scenarioType;
	}

	public void setScenarioType(String scenarioType) {
		this.scenarioType = scenarioType;
	}

}
