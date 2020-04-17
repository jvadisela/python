@SanityModule
Feature: Payload Validations

  @ValidationScenario(jsonfile='default.json')
  Scenario Outline: Age Validation
    Given REST API is running
    When payload has age as <age>
    Then status code is <status_code> but error msg is "<error_msg>"

  Examples:
    |age  |status_code|error_msg            |
    |25   |200        |null                 |
    |150  |200        |Invalid Age          |

  @ValidationScenario(jsonfile='ip_1.json')
  Scenario: Gender Validation
    Given REST API is running
    When payload has Gender as "X"
    Then status code is 200 but error msg is "Invalid Gender"
