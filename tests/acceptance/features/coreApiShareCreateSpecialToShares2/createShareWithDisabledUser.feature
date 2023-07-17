@api @issue-1328
Feature: share resources with a disabled user
  As a user
  I want to share resources to disabled user
  So that I can make sure it doesn't work

  Background:
    Given user "Alice" has been created with default attributes and without skeleton files
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "/textfile0.txt"

  @issue-2212
  Scenario: creating a new share with a disabled user
    Given using OCS API version "1"
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has been disabled
    When user "Alice" shares file "textfile0.txt" with user "Brian" using the sharing API
    And the HTTP status code should be "401"


  Scenario: creating a new share with a disabled user
    Given using OCS API version "2"
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has been disabled
    When user "Alice" shares file "textfile0.txt" with user "Brian" using the sharing API
    And the HTTP status code should be "401"
