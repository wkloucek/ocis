@api @files_trashbin-app-required @issue-ocis-reva-52 @S72e9d176
Feature: files and folders exist in the trashbin after being deleted
  As a user
  I want deleted files and folders to be available in the trashbin
  So that I can recover data easily

  Background:
    Given user "Alice" has been created with default attributes and without skeleton files
    And user "Alice" has uploaded file with content "to delete" to "/textfile0.txt"

  @smokeTest @Td4debec8
  Scenario Outline: deleting a file moves it to trashbin
    Given using <dav-path> DAV path
    When user "Alice" deletes file "/textfile0.txt" using the WebDAV API
    Then the HTTP status code should be "204"
    And as "Alice" file "/textfile0.txt" should exist in the trashbin
    But as "Alice" file "/textfile0.txt" should not exist
    Examples:
      | dav-path |
      | new      |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path |
      | spaces   |

  @smokeTest @T4af9863e
  Scenario Outline: deleting a folder moves it to trashbin
    Given using <dav-path> DAV path
    And user "Alice" has created folder "/tmp"
    When user "Alice" deletes folder "/tmp" using the WebDAV API
    Then the HTTP status code should be "204"
    And as "Alice" folder "/tmp" should exist in the trashbin
    Examples:
      | dav-path |
      | new      |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path |
      | spaces   |


  @T7e8d3d13
  Scenario Outline: deleting a file in a folder moves it to the trashbin root
    Given using <dav-path> DAV path
    And user "Alice" has created folder "/new-folder"
    And user "Alice" has moved file "/textfile0.txt" to "/new-folder/new-file.txt"
    When user "Alice" deletes file "/new-folder/new-file.txt" using the WebDAV API
    Then the HTTP status code should be "204"
    And as "Alice" the file with original path "/new-folder/new-file.txt" should exist in the trashbin
    And as "Alice" file "/new-file.txt" should exist in the trashbin
    But as "Alice" file "/new-folder/new-file.txt" should not exist
    Examples:
      | dav-path |
      | new      |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path |
      | spaces   |

  @files_sharing-app-required @T5a2c4b5f
  Scenario Outline: deleting a file in a shared folder moves it to the trashbin root
    Given using <dav-path> DAV path
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has created folder "/shared"
    And user "Alice" has moved file "/textfile0.txt" to "/shared/shared_file.txt"
    And user "Alice" has shared folder "/shared" with user "Brian"
    When user "Alice" deletes file "/shared/shared_file.txt" using the WebDAV API
    Then the HTTP status code should be "204"
    And as "Alice" the file with original path "/shared/shared_file.txt" should exist in the trashbin
    And as "Alice" file "/shared_file.txt" should exist in the trashbin
    But as "Alice" file "/shared/shared_file.txt" should not exist
    Examples:
      | dav-path |
      | new      |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path |
      | spaces   |

  @files_sharing-app-required @T81def62b
  Scenario Outline: deleting a shared folder moves it to trashbin
    Given using <dav-path> DAV path
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has created folder "/shared"
    And user "Alice" has moved file "/textfile0.txt" to "/shared/shared_file.txt"
    And user "Alice" has shared folder "/shared" with user "Brian"
    When user "Alice" deletes folder "/shared" using the WebDAV API
    Then the HTTP status code should be "204"
    And as "Alice" the folder with original path "/shared" should exist in the trashbin
    Examples:
      | dav-path |
      | new      |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path |
      | spaces   |


  # This scenario deletes many files as close together in time as the test can run.
  # On a very slow system, the file deletes might all happen in different seconds.
  # But on "reasonable" systems, some of the files will be deleted in the same second,

  @T050728b9
  Scenario Outline: trashbin can store two files with the same name but different origins when the files are deleted close together in time
    Given using <dav-path> DAV path
    And user "Alice" has created folder "/folderA"
    And user "Alice" has created folder "/folderB"
    And user "Alice" has created folder "/folderC"
    And user "Alice" has created folder "/folderD"
    And user "Alice" has copied file "/textfile0.txt" to "/folderA/textfile0.txt"
    And user "Alice" has copied file "/textfile0.txt" to "/folderB/textfile0.txt"
    And user "Alice" has copied file "/textfile0.txt" to "/folderC/textfile0.txt"
    And user "Alice" has copied file "/textfile0.txt" to "/folderD/textfile0.txt"
    When user "Alice" deletes these files without delays using the WebDAV API
      | /textfile0.txt         |
      | /folderA/textfile0.txt |
      | /folderB/textfile0.txt |
      | /folderC/textfile0.txt |
      | /folderD/textfile0.txt |
    Then the HTTP status code of responses on all endpoints should be "204"
    And as "Alice" the folder with original path "/folderA/textfile0.txt" should exist in the trashbin
    And as "Alice" the folder with original path "/folderB/textfile0.txt" should exist in the trashbin
    And as "Alice" the folder with original path "/folderC/textfile0.txt" should exist in the trashbin
    And as "Alice" the folder with original path "/folderD/textfile0.txt" should exist in the trashbin
    And as "Alice" the folder with original path "/textfile0.txt" should exist in the trashbin
    Examples:
      | dav-path |
      | new      |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path |
      | spaces   |


  @T2dd24eab
  Scenario Outline: trashbin can store two files with the same name but different origins when the deletes are separated by at least 1 second
    Given using <dav-path> DAV path
    And user "Alice" has created folder "/folderA"
    And user "Alice" has created folder "/folderB"
    And user "Alice" has copied file "/textfile0.txt" to "/folderA/textfile0.txt"
    And user "Alice" has copied file "/textfile0.txt" to "/folderB/textfile0.txt"
    When user "Alice" deletes file "/folderA/textfile0.txt" using the WebDAV API
    And user "Alice" deletes file "/folderB/textfile0.txt" using the WebDAV API
    And user "Alice" deletes file "/textfile0.txt" using the WebDAV API
    Then the HTTP status code of responses on all endpoints should be "204"
    And as "Alice" the folder with original path "/folderA/textfile0.txt" should exist in the trashbin
    And as "Alice" the folder with original path "/folderB/textfile0.txt" should exist in the trashbin
    And as "Alice" the folder with original path "/textfile0.txt" should exist in the trashbin
    Examples:
      | dav-path |
      | new      |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path |
      | spaces   |

  @local_storage @files_external-app-required @skipOnEncryptionType:user-keys @encryption-issue-42 @skip_on_objectstore @Ta5391086
  Scenario Outline: Deleting a folder into external storage moves it to the trashbin
    Given using <dav-path> DAV path
    And the administrator has invoked occ command "files:scan --all"
    And user "Alice" has created folder "/local_storage/tmp"
    And user "Alice" has moved file "/textfile0.txt" to "/local_storage/tmp/textfile0.txt"
    When user "Alice" deletes folder "/local_storage/tmp" using the WebDAV API
    Then the HTTP status code should be "204"
    And as "Alice" the folder with original path "/local_storage/tmp" should exist in the trashbin
    Examples:
      | dav-path |
      | new      |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path |
      | spaces   |

  @issue-ocis-3561 @skipOnLDAP @skip_on_objectstore @T4c6b1321
  Scenario Outline: Listing other user's trashbin is prohibited
    Given using <dav-path> DAV path
    And user "testtrashbin100" has been created with default attributes and without skeleton files
    And user "testtrashbin100" has uploaded file "filesForUpload/textfile.txt" to "/textfile1.txt"
    And user "Brian" has been created with default attributes and without skeleton files
    And user "testtrashbin100" has deleted file "/textfile1.txt"
    When user "Brian" tries to list the trashbin content for user "testtrashbin100"
    Then the HTTP status code should be "<status-code>"
    And the last webdav response should not contain the following elements
      | path          | user            |
      | textfile1.txt | testtrashbin100 |
    @skipOnOcis
    Examples:
      | dav-path | status-code |
      | new      | 401         |
    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path | status-code |
      | new      | 404         |
      | spaces   | 404         |

  @issue-ocis-3561 @smokeTest @skipOnLDAP @skip_on_objectstore @T5c92fc97
  Scenario Outline: Listing other user's trashbin is prohibited with multiple files on trashbin
    Given using <dav-path> DAV path
    And user "testtrashbin101" has been created with default attributes and without skeleton files
    And user "testtrashbin101" has uploaded file "filesForUpload/textfile.txt" to "/textfile0.txt"
    And user "testtrashbin101" has uploaded file "filesForUpload/textfile.txt" to "/textfile2.txt"
    And user "Brian" has been created with default attributes and without skeleton files
    And user "testtrashbin101" has deleted file "/textfile0.txt"
    And user "testtrashbin101" has deleted file "/textfile2.txt"
    When user "Brian" tries to list the trashbin content for user "testtrashbin101"
    Then the HTTP status code should be "<status-code>"
    And the last webdav response should not contain the following elements
      | path          | user            |
      | textfile0.txt | testtrashbin101 |
      | textfile2.txt | testtrashbin101 |
    @skipOnOcis
    Examples:
      | dav-path | status-code |
      | new      | 401         |
    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path | status-code |
      | new      | 404         |
      | spaces   | 404         |

  @issue-ocis-3561 @skipOnLDAP @skip_on_objectstore @provisioning_api-app-required @Tab375ec1
  Scenario Outline: Listing other user's trashbin is prohibited for newly recreated user with same name
    Given using <dav-path> DAV path
    And user "testtrashbin102" has been created with default attributes and without skeleton files
    And user "testtrashbin102" has uploaded file "filesForUpload/textfile.txt" to "/textfile0.txt"
    And user "testtrashbin102" has uploaded file "filesForUpload/textfile.txt" to "/textfile2.txt"
    And user "Brian" has been created with default attributes and without skeleton files
    And user "testtrashbin102" has deleted file "/textfile0.txt"
    And user "testtrashbin102" has deleted file "/textfile2.txt"
    And the administrator has deleted user "testtrashbin102" using the provisioning API
    And user "testtrashbin102" has been created with default attributes and without skeleton files
    And user "testtrashbin102" has uploaded file "filesForUpload/textfile.txt" to "/textfile3.txt"
    And user "testtrashbin102" has deleted file "/textfile3.txt"
    When user "Brian" tries to list the trashbin content for user "testtrashbin102"
    Then the HTTP status code should be "<status-code>"
    And the last webdav response should not contain the following elements
      | path          | user            |
      | textfile0.txt | testtrashbin102 |
      | textfile2.txt | testtrashbin102 |
      | textfile3.txt | testtrashbin102 |
    @skipOnOcis
    Examples:
      | dav-path | status-code |
      | new      | 401         |
    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path | status-code |
      | new      | 404         |
      | spaces   | 404         |

  @issue-ocis-3561 @skipOnLDAP @skip_on_objectstore @T58c77560
  Scenario Outline: Listing other user's empty unused trashbin is prohibited
    Given using <dav-path> DAV path
    And user "testtrashbinempty" has been created with default attributes and without skeleton files
    And user "testtrashbinempty" has uploaded file "filesForUpload/textfile.txt" to "/textfile1.txt"
    When user "Alice" tries to list the trashbin content for user "testtrashbinempty"
    Then the HTTP status code should be "<status-code>"
    @skipOnOcis
    Examples:
      | dav-path | status-code |
      | new      | 401         |
    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path | status-code |
      | new      | 404         |
      | spaces   | 404         |

  @issue-ocis-3561 @skipOnLDAP @skip_on_objectstore @T3d21fc31
  Scenario Outline: Listing non-existent user's trashbin is prohibited
    Given using <dav-path> DAV path
    When user "Alice" tries to list the trashbin content for user "testtrashbinnotauser"
    Then the HTTP status code should be "404"
    Examples:
      | dav-path |
      | new      |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path |
      | spaces   |

  @smokeTest @T4c20894e
  Scenario Outline: Get trashbin content with wrong password
    Given using <dav-path> DAV path
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "/textfile0.txt"
    And user "Alice" has deleted file "/textfile0.txt"
    When user "Alice" tries to list the trashbin content for user "Alice" using password "invalid"
    Then the HTTP status code should be "401"
    And the last webdav response should not contain the following elements
      | path           | user  |
      | /textfile0.txt | Alice |
    Examples:
      | dav-path |
      | new      |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path |
      | spaces   |

  @smokeTest @T896943d0
  Scenario Outline: Get trashbin content without password
    Given using <dav-path> DAV path
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "/textfile0.txt"
    And user "Alice" has deleted file "/textfile0.txt"
    When user "Alice" tries to list the trashbin content for user "Alice" using password ""
    Then the HTTP status code should be "401"
    And the last webdav response should not contain the following elements
      | path           | user  |
      | /textfile0.txt | Alice |
    Examples:
      | dav-path |
      | new      |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path |
      | spaces   |


  @T8f816715
  Scenario Outline: user with unusual username deletes a file
    Given using <dav-path> DAV path
    And user "<username>" has been created with default attributes and without skeleton files
    And user "<username>" has uploaded file with content "to delete" to "/textfile0.txt"
    When user "<username>" deletes file "/textfile0.txt" using the WebDAV API
    Then the HTTP status code should be "204"
    And as "<username>" file "/textfile0.txt" should exist in the trashbin
    But as "<username>" file "/textfile0.txt" should not exist
    Examples:
      | dav-path | username |
      | new      | dash-123 |
      | new      | null     |
      | new      | nil      |
      | new      | 123      |
      | new      | -123     |
      | new      | 0.0      |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path | username |
      | spaces   | dash-123 |
      | spaces   | null     |
      | spaces   | nil      |
      | spaces   | 123      |
      | spaces   | -123     |
      | spaces   | 0.0      |


  @T0715ef08
  Scenario Outline: deleting a file with comma in the filename moves it to trashbin
    Given using <dav-path> DAV path
    And user "Alice" has uploaded file with content "file with comma in filename" to "sample,1.txt"
    When user "Alice" deletes file "sample,1.txt" using the WebDAV API
    Then the HTTP status code should be "204"
    And as "Alice" file "sample,1.txt" should exist in the trashbin
    But as "Alice" file "sample,1.txt" should not exist
    Examples:
      | dav-path |
      | new      |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path |
      | spaces   |


  @T755c6764
  Scenario Outline: deleting a folder moves all its content to the trashbin
    Given using <dav-path> DAV path
    And user "Alice" has created folder "/new-folder"
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "/new-folder/new-file.txt"
    When user "Alice" deletes folder "/new-folder" using the WebDAV API
    Then the HTTP status code should be "204"
    And as "Alice" the file with original path "/new-folder/new-file.txt" should exist in the trashbin
    And as "Alice" the folder with original path "/new-folder" should exist in the trashbin
    And as "Alice" file "/new-folder/new-file.txt" should exist in the trashbin
    But as "Alice" file "/new-folder/new-file.txt" should not exist
    Examples:
      | dav-path |
      | new      |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path |
      | spaces   |

  @issue-ocis-541 @T5556d1be
  Scenario Outline: deleted file has appropriate deletion time information
    Given using <dav-path> DAV path
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "file.txt" with mtime "Thu, 08 Aug 2018 04:18:13 GMT" using the WebDAV API
    And user "Alice" has deleted file "file.txt"
    When user "Alice" tries to list the trashbin content for user "Alice"
    Then the HTTP status code should be "207"
    And the deleted file "file.txt" should have the correct deletion mtime in the response
    Examples:
      | dav-path |
      | new      |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path |
      | spaces   |

  @issue-ocis-1547 @T54ae38d7
  Scenario Outline: deleting files with special characters moves it to trashbin
    Given using <dav-path> DAV path
    And user "Alice" has uploaded the following files with content "special character file"
      | path             |
      | qa&dev.txt       |
      | !@tester$^.txt   |
      | %file *?2.txt    |
      | # %ab ab?=ed.txt |
    When user "Alice" deletes the following files
      | path             |
      | qa&dev.txt       |
      | !@tester$^.txt   |
      | %file *?2.txt    |
      | # %ab ab?=ed.txt |
    Then the HTTP status code of responses on all endpoints should be "204"
    And as "Alice" the following files should not exist
      | path             |
      | qa&dev.txt       |
      | !@tester$^.txt   |
      | %file *?2.txt    |
      | # %ab ab?=ed.txt |
    But as "Alice" the files with following original paths should exist in the trashbin
      | path             |
      | qa&dev.txt       |
      | !@tester$^.txt   |
      | %file *?2.txt    |
      | # %ab ab?=ed.txt |
    Examples:
      | dav-path |
      | new      |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path |
      | spaces   |

  @issue-ocis-1547 @T23a75d28
  Scenario Outline: deleting folders with special characters moves it to trashbin
    Given using <dav-path> DAV path
    And user "Alice" has created the following folders
      | path         |
      | qa&dev       |
      | !@tester$^   |
      | %file *?2    |
      | # %ab ab?=ed |
    When user "Alice" deletes the following folders
      | path         |
      | qa&dev       |
      | !@tester$^   |
      | %file *?2    |
      | # %ab ab?=ed |
    Then the HTTP status code of responses on all endpoints should be "204"
    But as "Alice" the following folders should not exist
      | path         |
      | qa&dev       |
      | !@tester$^   |
      | %file *?2    |
      | # %ab ab?=ed |
    And as "Alice" the folders with following original paths should exist in the trashbin
      | path         |
      | qa&dev       |
      | !@tester$^   |
      | %file *?2    |
      | # %ab ab?=ed |
    Examples:
      | dav-path |
      | new      |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav-path |
      | spaces   |
