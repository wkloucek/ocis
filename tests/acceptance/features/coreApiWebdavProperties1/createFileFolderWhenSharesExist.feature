@api
Feature: create file or folder named similar to Shares folder
  As a user
  I want to be able to create files and folders when the Shares folder exists
  So that I can organise the files in my file system

  Background:
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And user "Alice" has created folder "/FOLDER"
    And user "Alice" has shared folder "/FOLDER" with user "Brian" with permissions "read,update"
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"


  Scenario Outline: create a folder with a name similar to Shares
    Given using <dav-path-version> DAV path
    When user "Brian" creates folder "<folder_name>" using the WebDAV API
    Then the HTTP status code should be "201"
    And as "Brian" folder "<folder_name>" should exist
    And as "Brian" folder "/Shares" should exist
    Examples:
      | dav-path-version | folder_name |
      | old              | /Share      |
      | old              | /shares     |
      | old              | /Shares1    |
      | new              | /Share      |
      | new              | /shares     |
      | new              | /Shares1    |


  Scenario: create a file with a name similar to Shares
    Given using old DAV path
    And user "Alice" has shared folder "/FOLDER" with user "Brian" with permissions "read,update"
#    When user "Brian" uploads file with content "some text" to "/shares" using the WebDAV API
#    Then the HTTP status code should be "201"
#    And the content of file "/shares" for user "Brian" should be "some text"
#    And as "Brian" folder "/Shares" should exist
#    Examples:
#      | dav-path-version | file_name |
#      | old              | /Share    |
#      | old              | /shares   |
#      | old              | /Shares1  |
#      | new              | /Share    |
#      | new              | /shares   |
#      | new              | /Shares1  |


  Scenario Outline: try to create a folder named Shares
    Given using <dav-path-version> DAV path
    When user "Brian" creates folder "/Shares" using the WebDAV API
    Then the HTTP status code should be "405"
    And as "Brian" folder "/Shares" should exist
    And as "Brian" folder "/Shares/FOLDER" should exist
    Examples:
      | dav-path-version |
      | old              |
      | new              |


  Scenario Outline: try to create a file named Shares
    Given using <dav-path-version> DAV path
    When user "Brian" uploads file with content "some text" to "/Shares" using the WebDAV API
    Then the HTTP status code should be "409"
    And as "Brian" folder "/Shares" should exist
    And as "Brian" folder "/Shares/FOLDER" should exist
    Examples:
      | dav-path-version |
      | old              |
      | new              |
