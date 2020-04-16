@SanityModule
Feature: Payload Validations

  @ValidationScenario(jsonfile='default.json')
  Scenario: Age Validation
    Given REST API is running
    When payload has age as 20
    Then status code is 200 but error msg is "Invalid Age"

  @ValidationScenario(jsonfile='ip_1.json')
  Scenario: Gender Validation
    Given REST API is running
    When payload has Gender as "X"
    Then status code is 200 but error msg is "Invalid Gender"
