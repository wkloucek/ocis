@api @skipOnOcV10 @S92c9cf0b
Feature: get user's own information
  As user
  I want to be able to retrieve my own information
  So that I can see my information

  Background:
    Given user "Alice" has been created with default attributes and without skeleton files


  @T20b5df00
  Scenario: user gets his/her own information with no group involvement
    When the user "Alice" retrieves her information using the Graph API
    Then the HTTP status code should be "200"
    And the user retrieve API response should contain the following information:
      | displayName  | id        | mail              | onPremisesSamAccountName |
      | Alice Hansen | %uuid_v4% | alice@example.org | Alice                    |


  @T20e0e3bd
  Scenario: user gets his/her own information with group involvement
    Given group "tea-lover" has been created
    And group "coffee-lover" has been created
    And user "Alice" has been added to group "tea-lover"
    And user "Alice" has been added to group "coffee-lover"
    When the user "Alice" retrieves her information using the Graph API
    Then the HTTP status code should be "200"
    And the user retrieve API response should contain the following information:
      | displayName  | id        | mail              | onPremisesSamAccountName | memberOf                |
      | Alice Hansen | %uuid_v4% | alice@example.org | Alice                    | tea-lover, coffee-lover |
