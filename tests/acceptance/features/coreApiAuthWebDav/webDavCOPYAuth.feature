@api @S8d47ae2a
Feature: COPY file/folder

  As a user
  I want to copy a file or folder
  So that I can duplicate it

  Background:
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And user "Alice" has uploaded file with content "some data" to "/textfile0.txt"
    And user "Alice" has created folder "/PARENT"
    And user "Alice" has created folder "/FOLDER"
    And user "Alice" has uploaded file with content "some data" to "/PARENT/parent.txt"

  @smokeTest @skipOnBruteForceProtection @issue-brute_force_protection-112 @Te2cd7940
  Scenario: send COPY requests to webDav endpoints as normal user with wrong password
    When user "Alice" requests these endpoints with "COPY" using password "invalid" about user "Alice"
      | endpoint                                           |
      | /remote.php/webdav/textfile0.txt                   |
      | /remote.php/dav/files/%username%/textfile0.txt     |
      | /remote.php/webdav/PARENT                          |
      | /remote.php/dav/files/%username%/PARENT            |
      | /remote.php/dav/files/%username%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "401"

  @smokeTest @skipOnBruteForceProtection @issue-brute_force_protection-112 @skipOnOcV10 @personalSpace @T52c08513
  Scenario: send COPY requests to webDav endpoints as normal user with wrong password using the spaces WebDAV API
    When user "Alice" requests these endpoints with "COPY" using password "invalid" about user "Alice"
      | endpoint                                           |
      | /remote.php/dav/spaces/%spaceid%/textfile0.txt     |
      | /remote.php/dav/spaces/%spaceid%/PARENT            |
      | /remote.php/dav/spaces/%spaceid%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "401"

  @smokeTest @skipOnBruteForceProtection @issue-brute_force_protection-112 @T385313d7
  Scenario: send COPY requests to webDav endpoints as normal user with no password
    When user "Alice" requests these endpoints with "COPY" using password "" about user "Alice"
      | endpoint                                           |
      | /remote.php/webdav/textfile0.txt                   |
      | /remote.php/dav/files/%username%/textfile0.txt     |
      | /remote.php/webdav/PARENT                          |
      | /remote.php/dav/files/%username%/PARENT            |
      | /remote.php/dav/files/%username%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "401"

  @smokeTest @skipOnBruteForceProtection @issue-brute_force_protection-112 @skipOnOcV10 @personalSpace @Ta642a001
  Scenario: send COPY requests to webDav endpoints as normal user with no password using the spaces WebDAV API
    When user "Alice" requests these endpoints with "COPY" using password "" about user "Alice"
      | endpoint                                           |
      | /remote.php/dav/spaces/%spaceid%/textfile0.txt     |
      | /remote.php/dav/spaces/%spaceid%/PARENT            |
      | /remote.php/dav/spaces/%spaceid%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "401"

  @issue-ocis-reva-14 @T3466cb63
  Scenario: send COPY requests to another user's webDav endpoints as normal user
    When user "Brian" requests these endpoints with "COPY" about user "Alice"
      | endpoint                                           |
      | /remote.php/dav/files/%username%/textfile0.txt     |
      | /remote.php/dav/files/%username%/PARENT            |
      | /remote.php/dav/files/%username%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "403"

 @skipOnOcV10 @personalSpace @issue-ocis-reva-14 @Tdc78fa8f
 Scenario: send COPY requests to another user's webDav endpoints as normal user using the spaces WebDAV API
   When user "Brian" requests these endpoints with "COPY" about user "Alice"
     | endpoint                                           |
     | /remote.php/dav/spaces/%spaceid%/textfile0.txt     |
     | /remote.php/dav/spaces/%spaceid%/PARENT            |
     | /remote.php/dav/spaces/%spaceid%/PARENT/parent.txt |
   Then the HTTP status code of responses on all endpoints should be "403"


  @T5f63af08
  Scenario: send COPY requests to webDav endpoints using invalid username but correct password
    When user "usero" requests these endpoints with "COPY" using the password of user "Alice"
      | endpoint                                           |
      | /remote.php/webdav/textfile0.txt                   |
      | /remote.php/dav/files/%username%/textfile0.txt     |
      | /remote.php/webdav/PARENT                          |
      | /remote.php/dav/files/%username%/PARENT            |
      | /remote.php/dav/files/%username%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "401"

  @skipOnOcV10 @personalSpace @T2b56ed86
  Scenario: send COPY requests to webDav endpoints using invalid username but correct password using the spaces WebDAV API
    When user "usero" requests these endpoints with "COPY" using the password of user "Alice"
      | endpoint                                           |
      | /remote.php/dav/spaces/%spaceid%/textfile0.txt     |
      | /remote.php/dav/spaces/%spaceid%/PARENT            |
      | /remote.php/dav/spaces/%spaceid%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "401"


  @T5006e0f5
  Scenario: send COPY requests to webDav endpoints using valid password and username of different user
    When user "Brian" requests these endpoints with "COPY" using the password of user "Alice"
      | endpoint                                           |
      | /remote.php/webdav/textfile0.txt                   |
      | /remote.php/dav/files/%username%/textfile0.txt     |
      | /remote.php/webdav/PARENT                          |
      | /remote.php/dav/files/%username%/PARENT            |
      | /remote.php/dav/files/%username%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "401"

  @skipOnOcV10 @personalSpace @T1fdfae91
  Scenario: send COPY requests to webDav endpoints using valid password and username of different user using the spaces WebDAV API
    When user "Brian" requests these endpoints with "COPY" using the password of user "Alice"
      | endpoint                                           |
      | /remote.php/dav/spaces/%spaceid%/textfile0.txt     |
      | /remote.php/dav/spaces/%spaceid%/PARENT            |
      | /remote.php/dav/spaces/%spaceid%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "401"

  @smokeTest @skipOnBruteForceProtection @issue-brute_force_protection-112 @T8969a1e8
  Scenario: send COPY requests to webDav endpoints without any authentication
    When a user requests these endpoints with "COPY" with no authentication about user "Alice"
      | endpoint                                           |
      | /remote.php/webdav/textfile0.txt                   |
      | /remote.php/dav/files/%username%/textfile0.txt     |
      | /remote.php/webdav/PARENT                          |
      | /remote.php/dav/files/%username%/PARENT            |
      | /remote.php/dav/files/%username%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "401"

  @smokeTest @skipOnBruteForceProtection @issue-brute_force_protection-112 @skipOnOcV10 @personalSpace @Tf9fdfe08
  Scenario: send COPY requests to webDav endpoints without any authentication using the spaces WebDAV API
    When a user requests these endpoints with "COPY" with no authentication about user "Alice"
      | endpoint                                           |
      | /remote.php/dav/spaces/%spaceid%/textfile0.txt     |
      | /remote.php/dav/spaces/%spaceid%/PARENT            |
      | /remote.php/dav/spaces/%spaceid%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "401"

  @skipOnOcV10 @T906edf12
  Scenario: send COPY requests to webDav endpoints with body as normal user
    When user "Alice" requests these endpoints with "COPY" including body "doesnotmatter" about user "Alice"
      | endpoint                                           |
      | /remote.php/webdav/textfile0.txt                   |
      | /remote.php/dav/files/%username%/textfile0.txt     |
      | /remote.php/webdav/PARENT                          |
      | /remote.php/dav/files/%username%/PARENT            |
      | /remote.php/webdav/PARENT/parent.txt               |
      | /remote.php/dav/files/%username%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "415"

  @skipOnOcV10 @personalSpace @Tcdda5a41
  Scenario: send COPY requests to webDav endpoints with body as normal user using the spaces WebDAV API
    When user "Alice" requests these endpoints with "COPY" including body "doesnotmatter" about user "Alice"
      | endpoint                                           |
      | /remote.php/dav/spaces/%spaceid%/textfile0.txt     |
      | /remote.php/dav/spaces/%spaceid%/PARENT            |
      | /remote.php/dav/spaces/%spaceid%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "415"
