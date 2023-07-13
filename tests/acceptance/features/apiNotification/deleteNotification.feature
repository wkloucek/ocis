@api
Feature: Delete notification
  As a user
  I want to delete notifications
  So that I can filter notifications

  Background:
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And user "Alice" has uploaded file with content "other data" to "/textfile1.txt"
    And user "Alice" has created folder "my_data"
    And user "Alice" has shared folder "my_data" with user "Brian"
    And user "Alice" has shared file "/textfile1.txt" with user "Brian"


  Scenario: delete a notification
    When user "Brian" deletes a notification related to resource "my_data" with subject "Resource shared"
    Then the HTTP status code should be "200"
    But user "Brian" should not have a notification related to resource "my_data" with subject "Resource shared"
    And user "Brian" should have a notification with subject "Resource shared" and message:
      | message                                    |
      | Alice Hansen shared textfile1.txt with you |


  Scenario: delete all notifications
    When user "Brian" deletes all notifications
    Then the HTTP status code should be "200"
