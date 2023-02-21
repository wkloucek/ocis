@api @skipOnOcV10 @S04605578
Feature: sharing

  Background:
    Given using OCS API version "1"
    And these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And using spaces DAV path


  @T22988991
  Scenario: Correct webdav share-permissions for received file with edit and reshare permissions
    Given user "Alice" has uploaded file with content "foo" to "/tmp.txt"
    And user "Alice" has shared file "/tmp.txt" with user "Brian"
    And user "Brian" has accepted share "/tmp.txt" offered by user "Alice"
    When user "Brian" gets the following properties of file "/tmp.txt" inside space "Shares" using the WebDAV API
      | propertyName          |
      | ocs:share-permissions |
    Then the HTTP status code should be "200"
    And the single response should contain a property "ocs:share-permissions" with value "19"


  @T7afc69c5
  Scenario: Correct webdav share-permissions for received group shared file with edit and reshare permissions
    Given group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Alice" has uploaded file with content "foo" to "/tmp.txt"
    And user "Alice" has created a share with settings
      | path        | /tmp.txt          |
      | shareType   | group             |
      | permissions | share,update,read |
      | shareWith   | grp1              |
    And user "Brian" has accepted share "/tmp.txt" offered by user "Alice"
    When user "Brian" gets the following properties of file "/tmp.txt" inside space "Shares" using the WebDAV API
      | propertyName          |
      | ocs:share-permissions |
    Then the HTTP status code should be "200"
    And the single response should contain a property "ocs:share-permissions" with value "19"


  @T93220dde
  Scenario: Correct webdav share-permissions for received file with edit permissions but no reshare permissions
    Given user "Alice" has uploaded file with content "foo" to "/tmp.txt"
    And user "Alice" has shared file "tmp.txt" with user "Brian"
    And user "Brian" has accepted share "/tmp.txt" offered by user "Alice"
    When user "Alice" updates the last share using the sharing API with
      | permissions | update,read |
    Then the HTTP status code should be "200"
    And as user "Brian" file "/tmp.txt" inside space "Shares" should contain a property "ocs:share-permissions" with value "3"


  @T39cf078c
  Scenario: Correct webdav share-permissions for received group shared file with edit permissions but no reshare permissions
    Given group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Alice" has uploaded file with content "foo" to "/tmp.txt"
    And user "Alice" has created a share with settings
      | path        | /tmp.txt    |
      | shareType   | group       |
      | permissions | update,read |
      | shareWith   | grp1        |
    And user "Brian" has accepted share "/tmp.txt" offered by user "Alice"
    When user "Brian" gets the following properties of file "/tmp.txt" inside space "Shares" using the WebDAV API
      | propertyName          |
      | ocs:share-permissions |
    Then the HTTP status code should be "200"
    And the single response should contain a property "ocs:share-permissions" with value "3"


  @T71c23777
  Scenario: Correct webdav share-permissions for received file with reshare permissions but no edit permissions
    Given user "Alice" has uploaded file with content "foo" to "/tmp.txt"
    And user "Alice" has shared file "tmp.txt" with user "Brian"
    And user "Brian" has accepted share "/tmp.txt" offered by user "Alice"
    When user "Alice" updates the last share using the sharing API with
      | permissions | share,read |
    Then the HTTP status code should be "200"
    And as user "Brian" file "/tmp.txt" inside space "Shares" should contain a property "ocs:share-permissions" with value "17"


  @T71a0a928
  Scenario: Correct webdav share-permissions for received group shared file with reshare permissions but no edit permissions
    Given group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Alice" has uploaded file with content "foo" to "/tmp.txt"
    And user "Alice" has created a share with settings
      | path        | /tmp.txt   |
      | shareType   | group      |
      | permissions | share,read |
      | shareWith   | grp1       |
    And user "Brian" has accepted share "/tmp.txt" offered by user "Alice"
    When user "Brian" gets the following properties of file "/tmp.txt" inside space "Shares" using the WebDAV API
      | propertyName          |
      | ocs:share-permissions |
    Then the HTTP status code should be "200"
    And the single response should contain a property "ocs:share-permissions" with value "17"


  @T9d410f1f
  Scenario: Correct webdav share-permissions for received folder with all permissions
    Given user "Alice" has created folder "/tmp"
    And user "Alice" has shared file "/tmp" with user "Brian"
    And user "Brian" has accepted share "/tmp" offered by user "Alice"
    When user "Brian" gets the following properties of folder "/tmp" inside space "Shares" using the WebDAV API
      | propertyName          |
      | ocs:share-permissions |
    Then the HTTP status code should be "200"
    And the single response should contain a property "ocs:share-permissions" with value "31"


  @T6d4fa201
  Scenario: Correct webdav share-permissions for received group shared folder with all permissions
    Given group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Alice" has created folder "/tmp"
    And user "Alice" has created a share with settings
      | path      | tmp   |
      | shareType | group |
      | shareWith | grp1  |
    And user "Brian" has accepted share "/tmp" offered by user "Alice"
    When user "Brian" gets the following properties of folder "/tmp" inside space "Shares" using the WebDAV API
      | propertyName          |
      | ocs:share-permissions |
    Then the HTTP status code should be "200"
    And the single response should contain a property "ocs:share-permissions" with value "31"


  @T0de463a4
  Scenario: Correct webdav share-permissions for received folder with all permissions but edit
    Given user "Alice" has created folder "/tmp"
    And user "Alice" has shared file "/tmp" with user "Brian"
    And user "Brian" has accepted share "/tmp" offered by user "Alice"
    When user "Alice" updates the last share using the sharing API with
      | permissions | share,delete,create,read |
    Then the HTTP status code should be "200"
    And as user "Brian" folder "/tmp" inside space "Shares" should contain a property "ocs:share-permissions" with value "29"


  @Tc43cf51b
  Scenario: Correct webdav share-permissions for received group shared folder with all permissions but edit
    Given group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Alice" has created folder "/tmp"
    And user "Alice" has created a share with settings
      | path        | tmp                      |
      | shareType   | group                    |
      | shareWith   | grp1                     |
      | permissions | share,delete,create,read |
    And user "Brian" has accepted share "/tmp" offered by user "Alice"
     When user "Brian" gets the following properties of folder "/tmp" inside space "Shares" using the WebDAV API
      | propertyName          |
      | ocs:share-permissions |
    Then the HTTP status code should be "200"
    And the single response should contain a property "ocs:share-permissions" with value "29"


  @Tb5b7be40
  Scenario: Correct webdav share-permissions for received folder with all permissions but create
    Given user "Alice" has created folder "/tmp"
    And user "Alice" has shared file "/tmp" with user "Brian"
    And user "Brian" has accepted share "/tmp" offered by user "Alice"
    When user "Alice" updates the last share using the sharing API with
      | permissions | share,delete,update,read |
    Then the HTTP status code should be "200"
     And as user "Brian" folder "/tmp" inside space "Shares" should contain a property "ocs:share-permissions" with value "27"


  @T5c1ca911
  Scenario: Correct webdav share-permissions for received group shared folder with all permissions but create
    Given group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Alice" has created folder "/tmp"
    And user "Alice" has created a share with settings
      | path        | tmp                      |
      | shareType   | group                    |
      | shareWith   | grp1                     |
      | permissions | share,delete,update,read |
    And user "Brian" has accepted share "/tmp" offered by user "Alice"
    When user "Brian" gets the following properties of folder "/tmp" inside space "Shares" using the WebDAV API
      | propertyName          |
      | ocs:share-permissions |
    Then the HTTP status code should be "200"
    And the single response should contain a property "ocs:share-permissions" with value "27"


  @T84b653fa
  Scenario: Correct webdav share-permissions for received folder with all permissions but delete
    Given user "Alice" has created folder "/tmp"
    And user "Alice" has shared file "/tmp" with user "Brian"
    And user "Brian" has accepted share "/tmp" offered by user "Alice"
    When user "Alice" updates the last share using the sharing API with
      | permissions | share,create,update,read |
    Then the HTTP status code should be "200"
    And as user "Brian" folder "/tmp" inside space "Shares" should contain a property "ocs:share-permissions" with value "23"


  @T5eb71e68
  Scenario: Correct webdav share-permissions for received group shared folder with all permissions but delete
    Given group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Alice" has created folder "/tmp"
    And user "Alice" has created a share with settings
      | path        | tmp                      |
      | shareType   | group                    |
      | shareWith   | grp1                     |
      | permissions | share,create,update,read |
    And user "Brian" has accepted share "/tmp" offered by user "Alice"
    When user "Brian" gets the following properties of folder "/tmp" inside space "Shares" using the WebDAV API
      | propertyName          |
      | ocs:share-permissions |
    Then the HTTP status code should be "200"
    And the single response should contain a property "ocs:share-permissions" with value "23"


  @T9547d63c
  Scenario: Correct webdav share-permissions for received folder with all permissions but share
    Given user "Alice" has created folder "/tmp"
    And user "Alice" has shared file "/tmp" with user "Brian"
    And user "Brian" has accepted share "/tmp" offered by user "Alice"
    When user "Alice" updates the last share using the sharing API with
      | permissions | change |
    Then the HTTP status code should be "200"
    And as user "Brian" folder "/tmp" inside space "Shares" should contain a property "ocs:share-permissions" with value "15"


  @T1195fac4
  Scenario: Correct webdav share-permissions for received group shared folder with all permissions but share
    Given group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Alice" has created folder "/tmp"
    And user "Alice" has created a share with settings
      | path        | tmp    |
      | shareType   | group  |
      | shareWith   | grp1   |
      | permissions | change |
    And user "Brian" has accepted share "/tmp" offered by user "Alice"
    When user "Brian" gets the following properties of folder "/tmp" inside space "Shares" using the WebDAV API
      | propertyName          |
      | ocs:share-permissions |
    Then the HTTP status code should be "200"
    And the single response should contain a property "ocs:share-permissions" with value "15"


   @T4f3de5a7
   Scenario: Uploading a file to a folder received as a read-only group share
    Given group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Alice" has created folder "FOLDER"
    And user "Alice" has created a share with settings
      | path        | FOLDER |
      | shareType   | group  |
      | permissions | read   |
      | shareWith   | grp1   |
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"
    When user "Brian" uploads a file inside space "Shares" with content "new description" to "/FOLDER/textfile.txt" using the WebDAV API
    Then the HTTP status code should be "403"
    And as "Alice" file "/FOLDER/textfile.txt" should not exist


  @Tf504b98a
  Scenario: Uploading a file to a folder received as a upload-only user share
    Given user "Alice" has created folder "FOLDER"
    And user "Alice" has created a share with settings
      | path        | FOLDER |
      | shareType   | user   |
      | permissions | create |
      | shareWith   | Brian  |
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"
    When user "Brian" uploads a file inside space "Shares" with content "new description" to "/FOLDER/textfile.txt" using the WebDAV API
    Then the HTTP status code should be "201"
    And the following headers should match these regular expressions for user "Brian"
      | ETag | /^"[a-f0-9:\.]{1,32}"$/ |
    And the content of file "/FOLDER/textfile.txt" for user "Alice" should be:
    """
    new description
    """


  @T69ec386b
  Scenario: Uploading a file to a folder received as a upload-only group share
    Given group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Alice" has created folder "FOLDER"
    And user "Alice" has created a share with settings
      | path        | FOLDER |
      | shareType   | group  |
      | permissions | create |
      | shareWith   | grp1   |
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"
    When user "Brian" uploads a file inside space "Shares" with content "new description" to "/FOLDER/textfile.txt" using the WebDAV API
    Then the HTTP status code should be "201"
    And the following headers should match these regular expressions for user "Brian"
      | ETag | /^"[a-f0-9:\.]{1,32}"$/ |
    And the content of file "/FOLDER/textfile.txt" for user "Alice" should be:
    """
    new description
    """


  @Tcd98be72
  Scenario:  Uploading a file to a folder received as a read/write user share
    Given user "Alice" has created folder "FOLDER"
    And user "Alice" has created a share with settings
      | path        | FOLDER |
      | shareType   | user   |
      | permissions | change |
      | shareWith   | Brian  |
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"
    When user "Brian" uploads a file inside space "Shares" with content "new description" to "/FOLDER/textfile.txt" using the WebDAV API
    Then the HTTP status code should be "201"
    And the content of file "/FOLDER/textfile.txt" for user "Alice" should be:
    """
    new description
    """


  @T023dd40a
  Scenario: Uploading a file to a folder received as a read/write group share
    Given group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Alice" has created folder "FOLDER"
    And user "Alice" has created a share with settings
      | path        | FOLDER |
      | shareType   | group  |
      | permissions | change |
      | shareWith   | grp1   |
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"
    When user "Brian" uploads a file inside space "Shares" with content "new description" to "/FOLDER/textfile.txt" using the WebDAV API
    Then the HTTP status code should be "201"
    And the content of file "/FOLDER/textfile.txt" for user "Alice" should be:
    """
    new description
    """


 @Tf92c060b
 Scenario: Uploading to a user shared folder with read/write permission when the sharer has insufficient quota
    Given user "Alice" has created folder "FOLDER"
    And user "Alice" has created a share with settings
      | path        | FOLDER |
      | shareType   | user   |
      | permissions | change |
      | shareWith   | Brian  |
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"
    And user "Admin" has changed the quota of the personal space of "Alice Hansen" space to "1"
    When user "Brian" uploads a file inside space "Shares" with content "new description" to "/FOLDER/textfile.txt" using the WebDAV API
    Then the HTTP status code should be "507"
    And as "Alice" file "/FOLDER/textfile.txt" should not exist


  @T221f02cb
  Scenario: Uploading to a user shared folder with upload-only permission when the sharer has insufficient quota
    Given user "Alice" has created folder "FOLDER"
    And user "Alice" has created a share with settings
      | path        | FOLDER |
      | shareType   | user   |
      | permissions | create |
      | shareWith   | Brian  |
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"
    And user "Admin" has changed the quota of the personal space of "Alice Hansen" space to "1"
    When user "Brian" uploads a file inside space "Shares" with content "new description" to "/FOLDER/textfile.txt" using the WebDAV API
    Then the HTTP status code should be "507"
    And as "Alice" file "/FOLDER/textfile.txt" should not exist


   @T6fd5a373
   Scenario: Uploading a file to a group shared folder with upload-only permission when the sharer has insufficient quota
    Given group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Alice" has created folder "FOLDER"
    And user "Alice" has created a share with settings
      | path        | FOLDER |
      | shareType   | group  |
      | permissions | create |
      | shareWith   | grp1   |
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"
    And user "Admin" has changed the quota of the personal space of "Alice Hansen" space to "10"
    When user "Brian" uploads a file inside space "Shares" with content "new descriptionfgshsywhhh" to "/FOLDER/textfile.txt" using the WebDAV API
    Then the HTTP status code should be "507"
    And as "Alice" file "/FOLDER/textfile.txt" should not exist


  @Td9e295b0
  Scenario Outline: Sharer can download file uploaded with different permission by sharee to a shared folder
    Given user "Alice" has created folder "FOLDER"
    And user "Alice" has created a share with settings
      | path        | FOLDER        |
      | shareType   | user          |
      | permissions | <permissions> |
      | shareWith   | Brian         |
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"
    When user "Brian" uploads a file inside space "Shares" with content "some content" to "/FOLDER/textfile.txt" using the WebDAV API
    And user "Alice" downloads file "/FOLDER/textfile.txt" using the WebDAV API
    Then the HTTP status code should be "200"
    And the downloaded content should be "some content"
     Examples:
      | permissions |
      | change      |
      | create      |
