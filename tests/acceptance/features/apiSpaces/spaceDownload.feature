@api
Feature: Download space
  As a user
  I want to be able to download space
  So that I can store it in my local storage


    Scenario: user downloads a space
      Given user "Alice" has been created with default attributes and without skeleton files
      And using spaces DAV path
      And the administrator has assigned the role "Space Admin" to user "Alice" using the Graph API
      And user "Alice" has created a space "download space" with the default quota using the GraphApi
      And user "Alice" has uploaded a file inside space "download space" with content "some data" to "file1.txt"
      And user "Alice" has uploaded a file inside space "download space" with content "other data" to "file2.txt"
      And user "Alice" has uploaded a file inside space "download space" with content "more data" to "file3.txt"
      When user "Alice" downloads the space "download space" using the WebDAV API
      Then the HTTP status code should be "200"
      And the downloaded "tar" space archive should contain these files:
        | name      | content    |
        | file1.txt | some data  |
        | file2.txt | other data |
        | file3.txt | more data  |
