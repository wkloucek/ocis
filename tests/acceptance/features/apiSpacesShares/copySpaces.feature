@api @skipOnOcV10 @S0a4259d8
Feature: copy file
  As a user
  I want to be able to copy files
  So that I can manage my files

  Background:
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And using spaces DAV path


  @Te17a36db
  Scenario Outline: Copying a file within a same space project with role manager and editor
    Given the administrator has given "Alice" the role "Space Admin" using the settings api
    And user "Alice" has created a space "Project" with the default quota using the GraphApi
    And user "Alice" has created a folder "/newfolder" in space "Project"
    And user "Alice" has uploaded a file inside space "Project" with content "some content" to "/insideSpace.txt"
    And user "Alice" has shared a space "Project" to user "Brian" with role "<role>"
    When user "Brian" copies file "/insideSpace.txt" to "/newfolder/insideSpace.txt" inside space "Project" using the WebDAV API
    Then the HTTP status code should be "201"
    And for user "Brian" the space "Project" should contain these entries:
      | /newfolder/insideSpace.txt |
    And for user "Alice" the content of the file "/newfolder/insideSpace.txt" of the space "Project" should be "some content"
    Examples:
      | role    |
      | manager |
      | editor  |


  @T6ac37ba4
  Scenario: Copying a file within a same space project with role viewer
    Given the administrator has given "Alice" the role "Space Admin" using the settings api
    And user "Alice" has created a space "Project" with the default quota using the GraphApi
    And user "Alice" has created a folder "/newfolder" in space "Project"
    And user "Alice" has uploaded a file inside space "Project" with content "some content" to "insideSpace.txt"
    And user "Alice" has shared a space "Project" to user "Brian" with role "viewer"
    When user "Brian" copies file "/insideSpace.txt" to "/newfolder/insideSpace.txt" inside space "Project" using the WebDAV API
    Then the HTTP status code should be "403"
    And for user "Brian" the space "Project" should not contain these entries:
      | /newfolder/insideSpace.txt |


  @T66a300bd
  Scenario Outline: User copies a file from a space project with a different role to a space project with the manager role
    Given the administrator has given "Brian" the role "Space Admin" using the settings api
    And user "Brian" has created a space "Project1" with the default quota using the GraphApi
    And user "Brian" has created a space "Project2" with the default quota using the GraphApi
    And user "Brian" has uploaded a file inside space "Project1" with content "Project1 content" to "/project1.txt"
    And user "Brian" has shared a space "Project2" to user "Alice" with role "<to_role>"
    And user "Brian" has shared a space "Project1" to user "Alice" with role "<from_role>"
    When user "Alice" copies file "/project1.txt" from space "Project1" to "/project1.txt" inside space "Project2" using the WebDAV API
    Then the HTTP status code should be "201"
    And for user "Alice" the space "Project2" should contain these entries:
      | /project1.txt |
    And for user "Alice" the content of the file "/project1.txt" of the space "Project2" should be "Project1 content"
    Examples:
      | from_role | to_role |
      | manager   | manager |
      | manager   | editor  |
      | editor    | manager |
      | editor    | editor  |


  @Tc75ce2d5
  Scenario Outline: User copies a file from a space project with a different role to a space project with a viewer role
    Given the administrator has given "Brian" the role "Space Admin" using the settings api
    And user "Brian" has created a space "Project1" with the default quota using the GraphApi
    And user "Brian" has created a space "Project2" with the default quota using the GraphApi
    And user "Brian" has uploaded a file inside space "Project1" with content "Project1 content" to "/project1.txt"
    And user "Brian" has shared a space "Project2" to user "Alice" with role "viewer"
    And user "Brian" has shared a space "Project1" to user "Alice" with role "<role>"
    When user "Alice" copies file "/project1.txt" from space "Project1" to "/project1.txt" inside space "Project2" using the WebDAV API
    Then the HTTP status code should be "403"
    And for user "Alice" the space "Project2" should not contain these entries:
      | project1.txt |
    Examples:
      | role    |
      | manager |
      | editor  |


  @T68bd55a3
  Scenario Outline: User copies a file from space project with different role to space personal
    Given the administrator has given "Brian" the role "Space Admin" using the settings api
    And user "Brian" has created a space "Project" with the default quota using the GraphApi
    And user "Brian" has uploaded a file inside space "Project" with content "Project content" to "/project.txt"
    And user "Brian" has shared a space "Project" to user "Alice" with role "<role>"
    When user "Alice" copies file "/project.txt" from space "Project" to "/project.txt" inside space "Personal" using the WebDAV API
    Then the HTTP status code should be "201"
    And for user "Alice" the space "Personal" should contain these entries:
      | project.txt |
    And for user "Alice" the content of the file "/project.txt" of the space "Personal" should be "Project content"
    Examples:
      | role    |
      | manager |
      | editor  |
      | viewer  |


  @Te152e836
  Scenario Outline: User copies a file from space project with different role to space Shares with editor role
    Given the administrator has given "Brian" the role "Space Admin" using the settings api
    And user "Brian" has created a space "Project" with the default quota using the GraphApi
    And user "Brian" has created folder "/testshare"
    And user "Brian" has uploaded a file inside space "Project" with content "Project content" to "/project.txt"
    And user "Brian" has shared a space "Project" to user "Alice" with role "<role>"
    And user "Brian" has shared folder "/testshare" with user "Alice" with permissions "31"
    And user "Alice" has accepted share "/testshare" offered by user "Brian"
    When user "Alice" copies file "/project.txt" from space "Project" to "/testshare/project.txt" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "201"
    And for user "Alice" folder "testshare" of the space "Shares" should contain these files:
      | /project.txt |
    And for user "Alice" the content of the file "/testshare/project.txt" of the space "Shares" should be "Project content"
    Examples:
      | role    |
      | manager |
      | editor  |
      | viewer  |


  @T9fd20df4
  Scenario Outline: User copies a file from space project with different role to Shares with viewer role
    Given the administrator has given "Brian" the role "Space Admin" using the settings api
    And user "Brian" has created a space "Project" with the default quota using the GraphApi
    And user "Brian" has created folder "/testshare"
    And user "Brian" has uploaded a file inside space "Project" with content "Project content" to "/project.txt"
    And user "Brian" has shared a space "Project" to user "Alice" with role "<role>"
    And user "Brian" has shared folder "/testshare" with user "Alice" with permissions "17"
    And user "Alice" has accepted share "/testshare" offered by user "Brian"
    When user "Alice" copies file "/project.txt" from space "Project" to "/testshare/project.txt" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "403"
    And for user "Alice" the space "Shares" should not contain these entries:
      | /testshare/project.txt |
    Examples:
      | role    |
      | manager |
      | editor  |
      | viewer  |


  @T3b7a12a6
  Scenario Outline: User copies a file from space personal to space project with different role
    Given the administrator has given "Brian" the role "Space Admin" using the settings api
    And user "Brian" has created a space "Project" with the default quota using the GraphApi
    And user "Brian" has shared a space "Project" to user "Alice" with role "<role>"
    And user "Alice" has uploaded file with content "personal space content" to "/personal.txt"
    When user "Alice" copies file "/personal.txt" from space "Personal" to "/personal.txt" inside space "Project" using the WebDAV API
    Then the HTTP status code should be "201"
    And for user "Alice" the space "Project" should contain these entries:
      | /personal.txt |
    And for user "Alice" the content of the file "/personal.txt" of the space "Project" should be "personal space content"
    Examples:
      | role    |
      | manager |
      | editor  |


  @T7d00ef42
  Scenario: User copies a file from space personal to space project with role viewer
    Given the administrator has given "Brian" the role "Space Admin" using the settings api
    And user "Brian" has created a space "Project" with the default quota using the GraphApi
    And user "Brian" has shared a space "Project" to user "Alice" with role "viewer"
    And user "Alice" has uploaded file with content "personal space content" to "/personal.txt"
    When user "Alice" copies file "/personal.txt" from space "Personal" to "/personal.txt" inside space "Project" using the WebDAV API
    Then the HTTP status code should be "403"
    And for user "Alice" the space "Project" should not contain these entries:
      | /personal.txt |


  @T815a862a
  Scenario: User copies a file from space personal to space Shares with role editor
    Given user "Brian" has created folder "/testshare"
    And user "Brian" has shared folder "/testshare" with user "Alice" with permissions "31"
    And user "Alice" has accepted share "/testshare" offered by user "Brian"
    And user "Alice" has uploaded file with content "personal content" to "personal.txt"
    When user "Alice" copies file "/personal.txt" from space "Personal" to "/testshare/personal.txt" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "201"
    And for user "Alice" folder "testshare" of the space "Shares" should contain these files:
      | personal.txt |
    And for user "Alice" the content of the file "/testshare/personal.txt" of the space "Shares" should be "personal content"


  @T414db720
  Scenario: User copies a file from space personal to space Shares with role viewer
    Given user "Brian" has created folder "/testshare"
    And user "Brian" has shared folder "/testshare" with user "Alice" with permissions "17"
    And user "Alice" has accepted share "/testshare" offered by user "Brian"
    And user "Alice" has uploaded file with content "personal content" to "/personal.txt"
    When user "Alice" copies file "/personal.txt" from space "Personal" to "/testshare/personal.txt" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "403"
    And for user "Alice" the space "Shares" should not contain these entries:
      | /testshare/personal.txt |


  @T45dc13b2
  Scenario Outline: User copies a file from space Shares with different role to space personal
    Given the administrator has given "Brian" the role "Space Admin" using the settings api
    And user "Brian" has created folder "/testshare"
    And user "Brian" has uploaded file with content "testshare content" to "/testshare/testshare.txt"
    And user "Brian" has shared folder "/testshare" with user "Alice" with permissions "<permissions>"
    And user "Alice" has accepted share "/testshare" offered by user "Brian"
    When user "Alice" copies file "/testshare/testshare.txt" from space "Shares" to "/testshare.txt" inside space "Personal" using the WebDAV API
    Then the HTTP status code should be "201"
    And for user "Alice" the space "Personal" should contain these entries:
      | /testshare.txt |
    And for user "Alice" the content of the file "/testshare.txt" of the space "Personal" should be "testshare content"
    Examples:
      | permissions |
      | 31          |
      | 17          |


  @Td15c568d
  Scenario Outline: User copies a file from space Shares with different role to space project with different role
    Given the administrator has given "Brian" the role "Space Admin" using the settings api
    And user "Brian" has created a space "Project" with the default quota using the GraphApi
    And user "Brian" has shared a space "Project" to user "Alice" with role "<role>"
    And user "Brian" has created folder "/testshare"
    And user "Brian" has uploaded file with content "testshare content" to "/testshare/testshare.txt"
    And user "Brian" has shared folder "/testshare" with user "Alice" with permissions "<permissions>"
    And user "Alice" has accepted share "/testshare" offered by user "Brian"
    When user "Alice" copies file "/testshare/testshare.txt" from space "Shares" to "/testshare.txt" inside space "Project" using the WebDAV API
    Then the HTTP status code should be "201"
    And for user "Alice" the space "Project" should contain these entries:
      | /testshare.txt |
    And for user "Alice" the content of the file "/testshare.txt" of the space "Project" should be "testshare content"
    Examples:
      | role    | permissions |
      | manager | 31          |
      | manager | 17          |
      | editor  | 31          |
      | editor  | 17          |


  @T2d054fa1
  Scenario Outline: User copies a file from space Shares with different role to space project with role viewer
    Given the administrator has given "Brian" the role "Space Admin" using the settings api
    And user "Brian" has created a space "Project" with the default quota using the GraphApi
    And user "Brian" has shared a space "Project" to user "Alice" with role "viewer"
    And user "Brian" has created folder "/testshare"
    And user "Brian" has uploaded file with content "testshare content" to "/testshare/testshare.txt"
    And user "Brian" has shared folder "/testshare" with user "Alice" with permissions "<permissions>"
    And user "Alice" has accepted share "/testshare" offered by user "Brian"
    When user "Alice" copies file "/testshare/testshare.txt" from space "Shares" to "/testshare.txt" inside space "Project" using the WebDAV API
    Then the HTTP status code should be "403"
    And for user "Alice" the space "Project" should not contain these entries:
      | /testshare.txt |
    Examples:
      | permissions |
      | 31          |
      | 17          |


  @T5c299a65
  Scenario Outline: User copies a file from space Shares with different role to space Shares with role editor
    Given user "Brian" has created folder "/testshare1"
    And user "Brian" has created folder "/testshare2"
    And user "Brian" has uploaded file with content "testshare1 content" to "/testshare1/testshare1.txt"
    And user "Brian" has shared folder "/testshare1" with user "Alice" with permissions "<permissions>"
    And user "Brian" has shared folder "/testshare2" with user "Alice" with permissions "31"
    And user "Alice" has accepted share "/testshare1" offered by user "Brian"
    And user "Alice" has accepted share "/testshare2" offered by user "Brian"
    When user "Alice" copies file "/testshare1/testshare1.txt" from space "Shares" to "/testshare2/testshare1.txt" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "201"
    And for user "Alice" folder "testshare2" of the space "Shares" should contain these files:
      | /testshare1.txt |
    And for user "Brian" the space "Personal" should contain these entries:
      | /testshare2/testshare1.txt |
    And for user "Alice" the content of the file "/testshare2/testshare1.txt" of the space "Shares" should be "testshare1 content"
    And for user "Brian" the content of the file "/testshare1/testshare1.txt" of the space "Personal" should be "testshare1 content"
    Examples:
      | permissions |
      | 31          |
      | 17          |


  @T5c299a65
  Scenario Outline: User copies a file from space Shares with different role to space Shares with role editor
    Given user "Brian" has created folder "/testshare1"
    And user "Brian" has created folder "/testshare2"
    And user "Brian" has uploaded file with content "testshare1 content" to "/testshare1/testshare1.txt"
    And user "Brian" has shared folder "/testshare1" with user "Alice" with permissions "<permissions>"
    And user "Brian" has shared folder "/testshare2" with user "Alice" with permissions "17"
    And user "Alice" has accepted share "/testshare1" offered by user "Brian"
    And user "Alice" has accepted share "/testshare2" offered by user "Brian"
    When user "Alice" copies file "/testshare1/testshare1.txt" from space "Shares" to "/testshare2/testshare1.txt" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "403"
    And for user "Alice" the space "Shares" should not contain these entries:
      | /testshare2/testshare1.txt |
    And for user "Brian" the space "Personal" should not contain these entries:
      | /testshare2/testshare1.txt |
    Examples:
      | permissions |
      | 31          |
      | 17          |


  @T1b22cbb0
  Scenario Outline: Copying a folder within the same space project with different role
    Given the administrator has given "Alice" the role "Space Admin" using the settings api
    And user "Alice" has created a space "Project" with the default quota using the GraphApi
    And user "Alice" has created a folder "/folder1" in space "Project"
    And user "Alice" has created a folder "/folder2" in space "Project"
    And user "Alice" has uploaded a file inside space "Project" with content "some content" to "/folder2/demo.txt"
    And user "Alice" has shared a space "Project" to user "Brian" with role "<role>"
    When user "Brian" copies folder "/folder2" to "/folder1/folder2" inside space "Project" using the WebDAV API
    Then the HTTP status code should be "<status-code>"
    And for user "Brian" the space "Project" <shouldOrNot> contain these entries:
      | folder1/folder2/demo.txt |
    Examples:
      | role    | shouldOrNot | status-code |
      | manager | should      | 201         |
      | editor  | should      | 201         |
      | viewer  | should not  | 403         |


  @T7e64d84d
  Scenario Outline: User copies a folder from a space project with different role to a space project with different role
    Given the administrator has given "Brian" the role "Space Admin" using the settings api
    And user "Brian" has created a space "Project1" with the default quota using the GraphApi
    And user "Brian" has created a space "Project2" with the default quota using the GraphApi
    And user "Brian" has created a folder "/folder1" in space "Project1"
    And user "Brian" has uploaded a file inside space "Project1" with content "some content" to "/folder1/demo.txt"
    And user "Brian" has shared a space "Project2" to user "Alice" with role "<to_role>"
    And user "Brian" has shared a space "Project1" to user "Alice" with role "<from_role>"
    When user "Alice" copies folder "/folder1" from space "Project1" to "/folder1" inside space "Project2" using the WebDAV API
    Then the HTTP status code should be "<status-code>"
    And for user "Alice" the space "Project2" <shouldOrNot> contain these entries:
      | /folder1/demo.txt |
    Examples:
      | from_role | to_role | status-code | shouldOrNot |
      | manager   | manager | 201         | should      |
      | manager   | editor  | 201         | should      |
      | editor    | manager | 201         | should      |
      | editor    | editor  | 201         | should      |
      | manager   | viewer  | 403         | should not  |
      | editor    | viewer  | 403         | should not  |
      | viewer    | viewer  | 403         | should not  |


  @T169aed0e
  Scenario Outline: User copies a folder from space project with different role to space personal
    Given the administrator has given "Brian" the role "Space Admin" using the settings api
    And user "Brian" has created a space "Project" with the default quota using the GraphApi
    And user "Brian" has created a folder "/folder1" in space "Project"
    And user "Brian" has uploaded a file inside space "Project" with content "some content" to "/folder1/demo.txt"
    And user "Brian" has shared a space "Project" to user "Alice" with role "<role>"
    When user "Alice" copies file "/folder1" from space "Project" to "/folder1" inside space "Personal" using the WebDAV API
    Then the HTTP status code should be "201"
    And for user "Alice" the space "Personal" should contain these entries:
      | /folder1/demo.txt |
    Examples:
      | role    |
      | manager |
      | editor  |
      | viewer  |


  @T759d2bc1
  Scenario Outline: User copies a folder from space project with different role to space Shares with different role
    Given the administrator has given "Brian" the role "Space Admin" using the settings api
    And user "Brian" has created a space "Project" with the default quota using the GraphApi
    And user "Brian" has created folder "/testshare"
    And user "Brian" has created a folder "/folder1" in space "Project"
    And user "Brian" has uploaded a file inside space "Project" with content "some content" to "/folder1/demo.txt"
    And user "Brian" has shared a space "Project" to user "Alice" with role "<role>"
    And user "Brian" has shared folder "/testshare" with user "Alice" with permissions "<permissions>"
    And user "Alice" has accepted share "/testshare" offered by user "Brian"
    When user "Alice" copies folder "/folder1" from space "Project" to "/testshare/folder1" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "<status-code>"
    And for user "Alice" folder "testshare" of the space "Shares" <shouldOrNot> contain these files:
      | /folder1/demo.txt |
    Examples:
      | role    | shouldOrNot | permissions | status-code |
      | manager | should      | 31          | 201         |
      | editor  | should      | 31          | 201         |
      | viewer  | should      | 31          | 201         |
      | manager | should not  | 17          | 403         |
      | editor  | should not  | 17          | 403         |
      | viewer  | should not  | 17          | 403         |


  @Te6dc5b20
  Scenario Outline: User copies a folder from space personal to space project with different role
    Given the administrator has given "Brian" the role "Space Admin" using the settings api
    And user "Brian" has created a space "Project" with the default quota using the GraphApi
    And user "Brian" has shared a space "Project" to user "Alice" with role "<role>"
    And user "Alice" has created folder "/folder1"
    And user "Alice" has uploaded file with content "some content" to "folder1/demo.txt"
    When user "Alice" copies folder "/folder1" from space "Personal" to "/folder1" inside space "Project" using the WebDAV API
    Then the HTTP status code should be "<status-code>"
    And for user "Alice" the space "Project" <shouldOrNot> contain these entries:
      | /folder1/demo.txt |
    Examples:
      | role    | shouldOrNot | status-code |
      | manager | should      | 201         |
      | editor  | should      | 201         |
      | viewer  | should not  | 403         |


  @Tdbd1eaf3
  Scenario Outline: User copies a folder from space personal to space Shares with different permmissions
    Given user "Brian" has created folder "/testshare"
    And user "Brian" has shared folder "/testshare" with user "Alice" with permissions "<permissions>"
    And user "Alice" has accepted share "/testshare" offered by user "Brian"
    And user "Alice" has created folder "folder1"
    And user "Alice" has uploaded file with content "some content" to "folder1/demo.txt"
    When user "Alice" copies folder "/folder1" from space "Personal" to "/testshare/folder1" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "<status-code>"
    And for user "Alice" folder "testshare" of the space "Shares" <shouldOrNot> contain these files:
      | folder1/demo.txt |
    Examples:
      | permissions | shouldOrNot | status-code |
      | 31          | should      | 201         |
      | 17          | should not  | 403         |


  @Tabaf47a4
  Scenario Outline: User copies a folder from space Shares with different role to space personal
    Given the administrator has given "Brian" the role "Space Admin" using the settings api
    And user "Brian" has created folder "/testshare"
    And user "Brian" has uploaded file with content "testshare content" to "/testshare/testshare.txt"
    And user "Brian" has shared folder "/testshare" with user "Alice" with permissions "<permissions>"
    And user "Alice" has accepted share "/testshare" offered by user "Brian"
    When user "Alice" copies file "/testshare/testshare.txt" from space "Shares" to "/testshare.txt" inside space "Personal" using the WebDAV API
    Then the HTTP status code should be "201"
    And for user "Alice" the space "Personal" should contain these entries:
      | /testshare.txt |
    And for user "Alice" the content of the file "/testshare.txt" of the space "Personal" should be "testshare content"
    Examples:
      | permissions |
      | 31          |
      | 17          |


  @T4c9e8f97
  Scenario Outline: User copies a folder from space Shares with different role to space project with different role
    Given the administrator has given "Brian" the role "Space Admin" using the settings api
    And user "Brian" has created a space "Project" with the default quota using the GraphApi
    And user "Brian" has shared a space "Project" to user "Alice" with role "<role>"
    And user "Brian" has created folder "/testshare"
    And user "Brian" has created folder "/testshare/folder1"
    And user "Brian" has uploaded file with content "testshare content" to "/testshare/folder1/testshare.txt"
    And user "Brian" has shared folder "/testshare" with user "Alice" with permissions "<permissions>"
    And user "Alice" has accepted share "/testshare" offered by user "Brian"
    When user "Alice" copies folder "/testshare/folder1" from space "Shares" to "folder1" inside space "Project" using the WebDAV API
    Then the HTTP status code should be "201"
    And for user "Alice" the space "Project" should contain these entries:
      | /folder1/testshare.txt |
    Examples:
      | role    | permissions |
      | manager | 31          |
      | manager | 17          |
      | editor  | 31          |
      | editor  | 17          |


  @Tbe666ca9
  Scenario Outline: User copies a folder from space Shares with different role to space project with role viewer
    Given the administrator has given "Brian" the role "Space Admin" using the settings api
    And user "Brian" has created a space "Project" with the default quota using the GraphApi
    And user "Brian" has shared a space "Project" to user "Alice" with role "viewer"
    And user "Brian" has created folder "/testshare"
    And user "Brian" has created folder "/testshare/folder1"
    And user "Brian" has uploaded file with content "testshare content" to "/testshare/folder1/testshare.txt"
    And user "Brian" has shared folder "/testshare" with user "Alice" with permissions "<permissions>"
    And user "Alice" has accepted share "/testshare" offered by user "Brian"
    When user "Alice" copies folder "/testshare/folder1" from space "Shares" to "folder1" inside space "Project" using the WebDAV API
    Then the HTTP status code should be "403"
    And for user "Alice" the space "Project" should not contain these entries:
      | /folder1/testshare.txt |
    Examples:
      | permissions |
      | 31          |
      | 17          |


  @Ta1fe3c52
  Scenario: Copying a file to a folder with no permissions
    Given using spaces DAV path
    And user "Brian" has created folder "/testshare"
    And user "Brian" has created a share with settings
      | path        | testshare |
      | shareType   | user      |
      | permissions | read      |
      | shareWith   | Alice     |
    And user "Alice" has accepted share "/testshare" offered by user "Brian"
    And user "Alice" has uploaded file with content "ownCloud test text file 0" to "/textfile0.txt"
    When user "Alice" copies file "/textfile0.txt" from space "Personal" to "/testshare/textfile0.txt" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "403"
    And user "Alice" should not be able to download file "/testshare/textfile0.txt" from space "Shares"


  @T11be7c5f
  Scenario: Copying a file to overwrite a file into a folder with no permissions
    Given using spaces DAV path
    And user "Brian" has created folder "/testshare"
    And user "Brian" has uploaded file with content "ownCloud test text file 1" to "/testshare/overwritethis.txt"
    And user "Alice" has uploaded file with content "ownCloud test text file 0" to "/textfile0.txt"
    And user "Brian" has created a share with settings
      | path        | testshare |
      | shareType   | user      |
      | permissions | read      |
      | shareWith   | Alice     |
    And user "Alice" has accepted share "/testshare" offered by user "Brian"
    When user "Alice" copies file "/textfile0.txt" from space "Personal" to "/testshare/overwritethis.txt" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "403"
    And for user "Alice" the content of the file "/testshare/overwritethis.txt" of the space "Shares" should be "ownCloud test text file 1"


  @T1f2708b3
  Scenario: copy a file over the top of an existing folder received as a user share
    Given using spaces DAV path
    And user "Alice" has uploaded file with content "ownCloud test text file 1" to "/textfile1.txt"
    And user "Brian" has created folder "/BRIAN-Folder"
    And user "Brian" has created folder "BRIAN-Folder/sample-folder"
    And user "Brian" has shared folder "BRIAN-Folder" with user "Alice"
    And user "Alice" has accepted share "/BRIAN-Folder" offered by user "Brian"
    When user "Alice" copies file "/textfile1.txt" from space "Personal" to "/BRIAN-Folder" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "204"
    And for user "Alice" the content of the file "/BRIAN-Folder" of the space "Shares" should be "ownCloud test text file 1"
    And as "Alice" file "/textfile1.txt" should exist
    And user "Alice" should not have any received shares


  @T02c47f16
  Scenario: copy a folder over the top of an existing file received as a user share
    Given using spaces DAV path
    And user "Alice" has created folder "/FOLDER"
    And user "Alice" has created folder "/FOLDER/sample-folder"
    And user "Brian" has uploaded file with content "file to share" to "/sharedfile1.txt"
    And user "Brian" has shared file "/sharedfile1.txt" with user "Alice"
    And user "Alice" has accepted share "/sharedfile1.txt" offered by user "Brian"
    When user "Alice" copies folder "/FOLDER" from space "Personal" to "/sharedfile1.txt" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "204"
    And as "Alice" folder "/FOLDER/sample-folder" should exist
    And for user "Alice" folder "/sharedfile1.txt" of the space "Shares" should contain these files:
      | /sample-folder |
    And user "Alice" should not have any received shares


  @Tb7f656e3
  Scenario: copy a folder into another folder at different level which is received as a user share
    Given using spaces DAV path
    And user "Brian" has created folder "/BRIAN-FOLDER"
    And user "Brian" has created folder "/BRIAN-FOLDER/second-level-folder"
    And user "Brian" has created folder "/BRIAN-FOLDER/second-level-folder/third-level-folder"
    And user "Brian" has shared folder "/BRIAN-FOLDER" with user "Alice"
    And user "Alice" has accepted share "/BRIAN-FOLDER" offered by user "Brian"
    And user "Alice" has created folder "/Sample-Folder-A"
    And user "Alice" has created folder "/Sample-Folder-A/sample-folder-b"
    And user "Alice" has created folder "/Sample-Folder-A/sample-folder-b/sample-folder-c"
    When user "Alice" copies folder "/Sample-Folder-A/sample-folder-b" from space "Personal" to "/BRIAN-FOLDER/second-level-folder/third-level-folder" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "204"
    And as "Alice" folder "/Sample-Folder-A/sample-folder-b/sample-folder-c" should exist
    And for user "Alice" folder "BRIAN-FOLDER" of the space "Shares" should contain these entries:
      | /second-level-folder/third-level-folder/sample-folder-c/ |
    And for user "Brian" folder "BRIAN-FOLDER" of the space "Personal" should contain these files:
      | /second-level-folder/third-level-folder/sample-folder-c/ |
    And the response when user "Alice" gets the info of the last share should include
      | file_target | /Shares/BRIAN-FOLDER |


  @Tb6889d96
  Scenario: copy a file into a folder at different level received as a user share
    Given using spaces DAV path
    And user "Brian" has created folder "/BRIAN-FOLDER"
    And user "Brian" has created folder "/BRIAN-FOLDER/second-level-folder"
    And user "Brian" has created folder "/BRIAN-FOLDER/second-level-folder/third-level-folder"
    And user "Brian" has shared folder "/BRIAN-FOLDER" with user "Alice"
    And user "Alice" has accepted share "/BRIAN-FOLDER" offered by user "Brian"
    And user "Alice" has created folder "/Sample-Folder-A"
    And user "Alice" has created folder "/Sample-Folder-A/sample-folder-b"
    And user "Alice" has uploaded file with content "sample file-c" to "/Sample-Folder-A/sample-folder-b/textfile-c.txt"
    When user "Alice" copies file "/Sample-Folder-A/sample-folder-b/textfile-c.txt" from space "Personal" to "/BRIAN-FOLDER/second-level-folder" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "204"
    And for user "Alice" folder "BRIAN-FOLDER" of the space "Shares" should not contain these files:
      | /second-level-folder/third-level-folder |
    And as "Alice" file "Sample-Folder-A/sample-folder-b/textfile-c.txt" should exist
    And for user "Alice" folder "BRIAN-FOLDER" of the space "Shares" should contain these files:
      | /second-level-folder |
    And for user "Alice" the content of the file "/BRIAN-FOLDER/second-level-folder" of the space "Shares" should be "sample file-c"
    And for user "Brian" the content of the file "/BRIAN-FOLDER/second-level-folder" of the space "Personal" should be "sample file-c"
    And the response when user "Alice" gets the info of the last share should include
      | file_target | /Shares/BRIAN-FOLDER |


  @T02a87123
  Scenario: copy a file into a file at different level received as a user share
    Given using spaces DAV path
    And user "Brian" has created folder "/BRIAN-FOLDER"
    And user "Brian" has uploaded file with content "file at second level" to "/BRIAN-FOLDER/second-level-file.txt"
    And user "Brian" has shared folder "/BRIAN-FOLDER" with user "Alice"
    And user "Alice" has accepted share "/BRIAN-FOLDER" offered by user "Brian"
    And user "Alice" has created folder "/Sample-Folder-A"
    And user "Alice" has created folder "/Sample-Folder-A/sample-folder-b"
    And user "Alice" has uploaded file with content "sample file-c" to "/Sample-Folder-A/sample-folder-b/textfile-c.txt"
    When user "Alice" copies file "/Sample-Folder-A/sample-folder-b/textfile-c.txt" from space "Personal" to "/BRIAN-FOLDER/second-level-file.txt" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "204"
    And as "Alice" file "Sample-Folder-A/sample-folder-b/textfile-c.txt" should exist
    And for user "Alice" folder "BRIAN-FOLDER" of the space "Shares" should contain these files:
      | /second-level-file.txt |
    And for user "Alice" folder "BRIAN-FOLDER" of the space "Shares" should not contain these files:
      | /textfile-c.txt |
    And for user "Alice" the content of the file "/BRIAN-FOLDER/second-level-file.txt" of the space "Shares" should be "sample file-c"
    And for user "Brian" the content of the file "/BRIAN-FOLDER/second-level-file.txt" of the space "Personal" should be "sample file-c"
    And the response when user "Alice" gets the info of the last share should include
      | file_target | /Shares/BRIAN-FOLDER |


  @T5c502a86
  Scenario: copy a folder into a file at different level received as a user share
    Given using spaces DAV path
    And user "Alice" has created folder "/FOLDER"
    And user "Alice" has created folder "/FOLDER/second-level-folder"
    And user "Alice" has created folder "/FOLDER/second-level-folder/third-level-folder"
    And user "Brian" has created folder "/BRIAN-FOLDER"
    And user "Brian" has created folder "/BRIAN-FOLDER/second-level-folder"
    And user "Brian" has uploaded file with content "file at third level" to "BRIAN-FOLDER/second-level-folder/third-level-file.txt"
    And user "Brian" has shared folder "/BRIAN-FOLDER" with user "Alice"
    And user "Alice" has accepted share "/BRIAN-FOLDER" offered by user "Brian"
    When user "Alice" copies folder "/FOLDER/second-level-folder" from space "Personal" to "/BRIAN-FOLDER/second-level-folder/third-level-file.txt" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "204"
    And for user "Alice" folder "BRIAN-FOLDER" of the space "Shares" should contain these entries:
      | /second-level-folder/third-level-file.txt/third-level-folder |
    And for user "Alice" folder "BRIAN-FOLDER" of the space "Shares" should not contain these entries:
      | /second-level-folder/second-level-folder/ |
    And the response when user "Alice" gets the info of the last share should include
      | file_target | /Shares/BRIAN-FOLDER |


  @Tc8087baf
  Scenario: copy a folder into another folder at different level which is received as a group share
    Given using spaces DAV path
    And group "grp1" has been created
    And user "Alice" has been added to group "grp1"
    And user "Brian" has been added to group "grp1"
    And user "Brian" has created folder "/BRIAN-FOLDER"
    And user "Brian" has created folder "/BRIAN-FOLDER/second-level-folder"
    And user "Brian" has created folder "/BRIAN-FOLDER/second-level-folder/third-level-folder"
    And user "Brian" has shared folder "/BRIAN-FOLDER" with group "grp1"
    And user "Alice" has accepted share "/BRIAN-FOLDER" offered by user "Brian"
    And user "Alice" has created folder "/Sample-Folder-A"
    And user "Alice" has created folder "/Sample-Folder-A/sample-folder-b"
    And user "Alice" has created folder "/Sample-Folder-A/sample-folder-b/sample-folder-c"
    When user "Alice" copies folder "/Sample-Folder-A/sample-folder-b" from space "Personal" to "/BRIAN-FOLDER/second-level-folder/third-level-folder" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "204"
    And as "Alice" folder "/Sample-Folder-A/sample-folder-b/sample-folder-c" should exist
    And for user "Alice" folder "BRIAN-FOLDER" of the space "Shares" should contain these files:
      | /second-level-folder/third-level-folder/sample-folder-c/ |
    And the response when user "Alice" gets the info of the last share should include
      | file_target | /Shares/BRIAN-FOLDER |


  @T384dd2a2
  Scenario: copy a file into a folder at different level received as a group share
    Given using spaces DAV path
    And group "grp1" has been created
    And user "Alice" has been added to group "grp1"
    And user "Brian" has been added to group "grp1"
    And user "Brian" has created folder "/BRIAN-FOLDER"
    And user "Brian" has created folder "/BRIAN-FOLDER/second-level-folder"
    And user "Brian" has created folder "/BRIAN-FOLDER/second-level-folder/third-level-folder"
    And user "Brian" has shared folder "/BRIAN-FOLDER" with group "grp1"
    And user "Alice" has accepted share "/BRIAN-FOLDER" offered by user "Brian"
    And user "Alice" has created folder "/Sample-Folder-A"
    And user "Alice" has created folder "/Sample-Folder-A/sample-folder-b"
    And user "Alice" has uploaded file with content "sample file-c" to "/Sample-Folder-A/sample-folder-b/textfile-c.txt"
    When user "Alice" copies file "/Sample-Folder-A/sample-folder-b/textfile-c.txt" from space "Personal" to "/BRIAN-FOLDER/second-level-folder" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "204"
    And for user "Alice" folder "BRIAN-FOLDER" of the space "Shares" should not contain these entries:
      | /second-level-folder/third-level-folder |
    And for user "Alice" the content of the file "/BRIAN-FOLDER/second-level-folder" of the space "Shares" should be "sample file-c"
    And for user "Brian" the content of the file "/BRIAN-FOLDER/second-level-folder" of the space "Personal" should be "sample file-c"
    And the response when user "Alice" gets the info of the last share should include
      | file_target | /Shares/BRIAN-FOLDER |


  @T136133f9
  Scenario: overwrite a file received as a group share with a file from different level
    Given using spaces DAV path
    And group "grp1" has been created
    And user "Alice" has been added to group "grp1"
    And user "Brian" has been added to group "grp1"
    And user "Brian" has created folder "BRIAN-FOLDER"
    And user "Brian" has uploaded file with content "file at second level" to "/BRIAN-FOLDER/second-level-file.txt"
    And user "Brian" has shared folder "/BRIAN-FOLDER" with group "grp1"
    And user "Alice" has accepted share "/BRIAN-FOLDER" offered by user "Brian"
    And user "Alice" has created folder "/Sample-Folder-A"
    And user "Alice" has created folder "/Sample-Folder-A/sample-folder-b"
    And user "Alice" has uploaded file with content "sample file-c" to "/Sample-Folder-A/sample-folder-b/textfile-c.txt"
    When user "Alice" copies file "/Sample-Folder-A/sample-folder-b/textfile-c.txt" from space "Personal" to "/BRIAN-FOLDER/second-level-file.txt" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "204"
    And as "Alice" file "/Sample-Folder-A/sample-folder-b/textfile-c.txt" should exist
    And for user "Alice" folder "/BRIAN-FOLDER" of the space "Shares" should not contain these files:
      | /textfile-c.txt |
    And as "Alice" file "/Sample-Folder-A/sample-folder-b/textfile-c.txt" should exist
    And for user "Alice" the content of the file "/BRIAN-FOLDER/second-level-file.txt" of the space "Shares" should be "sample file-c"
    And for user "Brian" the content of the file "/BRIAN-FOLDER/second-level-file.txt" of the space "Personal" should be "sample file-c"
    And the response when user "Alice" gets the info of the last share should include
      | file_target | /Shares/BRIAN-FOLDER |


  @Ta3c9f5cd
  Scenario: copy a folder into a file at different level received as a group share
    Given using spaces DAV path
    And group "grp1" has been created
    And user "Alice" has been added to group "grp1"
    And user "Brian" has been added to group "grp1"
    And user "Brian" has created folder "/BRIAN-FOLDER"
    And user "Brian" has created folder "/BRIAN-FOLDER/second-level-folder"
    And user "Brian" has uploaded file with content "file at third level" to "/BRIAN-FOLDER/second-level-folder/third-level-file.txt"
    And user "Brian" has shared folder "/BRIAN-FOLDER" with group "grp1"
    And user "Alice" has accepted share "/BRIAN-FOLDER" offered by user "Brian"
    And user "Alice" has created folder "/FOLDER"
    And user "Alice" has created folder "/FOLDER/second-level-folder"
    And user "Alice" has created folder "/FOLDER/second-level-folder/third-level-folder"
    When user "Alice" copies folder "/FOLDER/second-level-folder" from space "Personal" to "/BRIAN-FOLDER/second-level-folder/third-level-file.txt" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "204"
    And for user "Alice" folder "BRIAN-FOLDER" of the space "Shares" should contain these files:
      | /second-level-folder/third-level-file.txt/                    |
      | /second-level-folder/third-level-file.txt/third-level-folder/ |
    And as "Alice" folder "FOLDER/second-level-folder/third-level-folder" should exist
    And for user "Alice" folder "BRIAN-FOLDER" of the space "Shares" should not contain these files:
      | /second-level-folder/second-level-folder |
    And the response when user "Alice" gets the info of the last share should include
      | file_target | /Shares/BRIAN-FOLDER |


  @T1e9a0f79
  Scenario: Copying a file with an option "keep both" inside of the project space
    Given the administrator has given "Alice" the role "Space Admin" using the settings api
    And user "Alice" has created a space "Project" with the default quota using the GraphApi
    And user "Alice" has created a folder "/newfolder" in space "Project"
    And user "Alice" has uploaded a file inside space "Project" with content "some content" to "/newfolder/insideSpace.txt"
    And user "Alice" has uploaded a file inside space "Project" with content "new content" to "/insideSpace.txt"
    When user "Alice" copies file "/insideSpace.txt" to "/newfolder/insideSpace (1).txt" inside space "Project" using the WebDAV API
    Then the HTTP status code should be "201"
    And for user "Alice" the space "Project" should contain these entries:
      | newfolder/insideSpace.txt     |
      | newfolder/insideSpace (1).txt |
    And for user "Alice" the content of the file "/newfolder/insideSpace (1).txt" of the space "Project" should be "new content"


  @T3d9fec16
  Scenario: Copying a file with an option "replace" inside of the project space
    Given the administrator has given "Alice" the role "Space Admin" using the settings api
    And user "Alice" has created a space "Project" with the default quota using the GraphApi
    And user "Alice" has created a folder "/newfolder" in space "Project"
    And user "Alice" has uploaded a file inside space "Project" with content "old content version 1" to "/newfolder/insideSpace.txt"
    And user "Alice" has uploaded a file inside space "Project" with content "old content version 2" to "/newfolder/insideSpace.txt"
    And user "Alice" has uploaded a file inside space "Project" with content "new content" to "/insideSpace.txt"
    When user "Alice" overwrites file "/insideSpace.txt" from space "Project" to "/newfolder/insideSpace.txt" inside space "Project" while copying using the WebDAV API
    Then the HTTP status code should be "204"
    And for user "Alice" the content of the file "/newfolder/insideSpace.txt" of the space "Project" should be "new content"
    When user "Alice" downloads version of the file "/newfolder/insideSpace.txt" with the index "2" of the space "Project" using the WebDAV API
    Then the HTTP status code should be "200"
    And the downloaded content should be "old content version 1"
    When user "Alice" downloads version of the file "/newfolder/insideSpace.txt" with the index "1" of the space "Project" using the WebDAV API
    Then the HTTP status code should be "200"
    And the downloaded content should be "old content version 2"
    And as "Alice" file "insideSpace.txt" should not exist in the trashbin of the space "Project"


  @T0461f60b
  Scenario: Copying a file from Personal to Shares with an option "keep both"
    Given the administrator has given "Alice" the role "Space Admin" using the settings api
    And user "Alice" has created a space "Project" with the default quota using the GraphApi
    And user "Alice" has created a folder "/newfolder" in space "Project"
    And user "Alice" has uploaded a file inside space "Project" with content "some content" to "/newfolder/personal.txt"
    And user "Alice" creates a share inside of space "Project" with settings:
      | path      | newfolder |
      | shareWith | Brian     |
      | role      | editor    |
    And user "Brian" has accepted share "/newfolder" offered by user "Alice"
    And user "Brian" has uploaded file with content "new content" to "/personal.txt"
    When user "Brian" copies file "/personal.txt" from space "Personal" to "/newfolder/personal (1).txt" inside space "Shares" using the WebDAV API
    Then the HTTP status code should be "201"
    And for user "Alice" the space "Project" should contain these entries:
      | newfolder/personal.txt     |
      | newfolder/personal (1).txt |
    And for user "Alice" the content of the file "/newfolder/personal (1).txt" of the space "Project" should be "new content"
    And for user "Brian" the space "Shares" should contain these entries:
      | newfolder/personal.txt     |
      | newfolder/personal (1).txt |


  @T5fac0edb
  Scenario: Copying a file from Personal to Shares with an option "replace"
    Given the administrator has given "Alice" the role "Space Admin" using the settings api
    And user "Alice" has created a space "Project" with the default quota using the GraphApi
    And user "Alice" has created a folder "/newfolder" in space "Project"
    And user "Alice" has uploaded a file inside space "Project" with content "old content version 1" to "/newfolder/personal.txt"
    And user "Alice" has uploaded a file inside space "Project" with content "old content version 2" to "/newfolder/personal.txt"
    And user "Alice" creates a share inside of space "Project" with settings:
      | path      | newfolder |
      | shareWith | Brian     |
      | role      | editor    |
    And user "Brian" has accepted share "/newfolder" offered by user "Alice"
    And user "Brian" has uploaded file with content "new content" to "/personal.txt"
    When user "Brian" overwrites file "/personal.txt" from space "Personal" to "/newfolder/personal.txt" inside space "Shares" while copying using the WebDAV API
    Then the HTTP status code should be "204"
    And for user "Alice" the space "Project" should contain these entries:
      | newfolder/personal.txt |
    And for user "Alice" the content of the file "/newfolder/personal.txt" of the space "Project" should be "new content"
    When user "Alice" downloads version of the file "/newfolder/personal.txt" with the index "1" of the space "Project" using the WebDAV API
    Then the HTTP status code should be "200"
    And the downloaded content should be "old content version 2"
    And for user "Brian" the content of the file "/newfolder/personal.txt" of the space "Shares" should be "new content"
    When user "Brian" downloads version of the file "/newfolder/personal.txt" with the index "2" of the space "Shares" using the WebDAV API
    Then the HTTP status code should be "200"
    And the downloaded content should be "old content version 1"
    And as "Brian" file "insideSpace.txt" should not exist in the trashbin of the space "Personal"
