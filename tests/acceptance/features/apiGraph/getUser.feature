@api @skipOnOcV10 @Sd671bff3
Feature: get users
  As an admin
  I want to be able to retrieve user information
  So that I can see the information

  Background:
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And the administrator has given "Alice" the role "Admin" using the settings api


  @Tacfb0b38
  Scenario: admin user gets the information of a user
    When user "Alice" gets information of user "Brian" using Graph API
    Then the HTTP status code should be "200"
    And the user retrieve API response should contain the following information:
      | displayName  | id        | mail              | onPremisesSamAccountName |
      | Brian Murphy | %uuid_v4% | brian@example.org | Brian                    |


  @T53a85074
  Scenario: non-admin user tries to get the information of a user
    When user "Brian" tries to get information of user "Alice" using Graph API
    Then the HTTP status code should be "401"
    And the last response should be an unauthorized response


  @Tb8b2acd1
  Scenario: admin user gets all users
    When user "Alice" gets all users using the Graph API
    Then the HTTP status code should be "200"
    And the API response should contain following users with the information:
      | displayName  | id        | mail              | onPremisesSamAccountName |
      | Alice Hansen | %uuid_v4% | alice@example.org | Alice                    |
      | Brian Murphy | %uuid_v4% | brian@example.org | Brian                    |


  @Te85d46d1
  Scenario: non-admin user tries to get all users
    When user "Brian" tries to get all users using the Graph API
    Then the HTTP status code should be "401"
    And the last response should be an unauthorized response


  @T61c076e0
  Scenario: admin user gets the drive information of a user
    When the user "Alice" gets user "Brian" along with his drive information using Graph API
    Then the HTTP status code should be "200"
    And the user retrieve API response should contain the following information:
      | displayName  | id        | mail              | onPremisesSamAccountName |
      | Brian Murphy | %uuid_v4% | brian@example.org | Brian                    |
    And the user retrieve API response should contain the following drive information:
      | driveType         | personal                         |
      | driveAlias        | personal/brian                   |
      | id                | %space_id%                       |
      | name              | Brian Murphy                     |
      | owner@@@user@@@id | %user_id%                        |
      | quota@@@state     | normal                           |
      | root@@@id         | %space_id%                       |
      | root@@@webDavUrl  | %base_url%/dav/spaces/%space_id% |
      | webUrl            | %base_url%/f/%space_id%          |


  @Ta43ac42a
  Scenario: normal user gets his/her own drive information
    When the user "Brian" gets his drive information using Graph API
    Then the HTTP status code should be "200"
    And the user retrieve API response should contain the following information:
      | displayName  | id        | mail              | onPremisesSamAccountName |
      | Brian Murphy | %uuid_v4% | brian@example.org | Brian                    |
    And the user retrieve API response should contain the following drive information:
      | driveType         | personal                         |
      | driveAlias        | personal/brian                   |
      | id                | %space_id%                       |
      | name              | Brian Murphy                     |
      | owner@@@user@@@id | %user_id%                        |
      | quota@@@state     | normal                           |
      | root@@@id         | %space_id%                       |
      | root@@@webDavUrl  | %base_url%/dav/spaces/%space_id% |
      | webUrl            | %base_url%/f/%space_id%          |


  @T92955e86
  Scenario: admin user gets the group information of a user
    Given group "tea-lover" has been created
    And group "coffee-lover" has been created
    And user "Brian" has been added to group "tea-lover"
    And user "Brian" has been added to group "coffee-lover"
    When the user "Alice" gets user "Brian" along with his group information using Graph API
    Then the HTTP status code should be "200"
    And the user retrieve API response should contain the following information:
      | displayName  | id        | mail              | onPremisesSamAccountName | memberOf                |
      | Brian Murphy | %uuid_v4% | brian@example.org | Brian                    | tea-lover, coffee-lover |


  @T38c4427e
  Scenario: non-admin user tries to get the group information of a user
    Given user "Carol" has been created with default attributes and without skeleton files
    And group "coffee-lover" has been created
    And user "Brian" has been added to group "coffee-lover"
    When the user "Carol" gets user "Brian" along with his group information using Graph API
    Then the HTTP status code should be "401"
    And the last response should be an unauthorized response


  @Td61518cb
  Scenario: admin user gets all users of certain groups
    Given user "Carol" has been created with default attributes and without skeleton files
    And group "tea-lover" has been created
    And group "coffee-lover" has been created
    And user "Alice" has been added to group "tea-lover"
    And user "Brian" has been added to group "tea-lover"
    And user "Brian" has been added to group "coffee-lover"
    When the user "Alice" gets all users of the group "tea-lover" using the Graph API
    Then the HTTP status code should be "200"
    And the API response should contain following users with the information:
      | displayName  | id        | mail              | onPremisesSamAccountName |
      | Alice Hansen | %uuid_v4% | alice@example.org | Alice                    |
      | Brian Murphy | %uuid_v4% | brian@example.org | Brian                    |
    But the API response should not contain following user with the information:
      | displayName | id        | mail              | onPremisesSamAccountName |
      | Carol King  | %uuid_v4% | carol@example.org | Carol                    |
    When the user "Alice" gets all users of two groups "tea-lover,coffee-lover" using the Graph API
    Then the HTTP status code should be "200"
    And the API response should contain following user with the information:
      | displayName  | id        | mail              | onPremisesSamAccountName |
      | Brian Murphy | %uuid_v4% | brian@example.org | Brian                    |
    But the API response should not contain following users with the information:
      | displayName  | id        | mail              | onPremisesSamAccountName |
      | Alice Hansen | %uuid_v4% | alice@example.org | Alice                    |
      | Carol King   | %uuid_v4% | carol@example.org | Carol                    |
