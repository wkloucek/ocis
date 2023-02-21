@api @S7a3f972a
Feature: get file properties
  As a user
  I want to be able to get meta-information about files
  So that I can know file meta-information (detailed requirement TBD)

  Background:
    Given using OCS API version "1"
    And user "Alice" has been created with default attributes and without skeleton files

  @smokeTest @Tab07ea37
  Scenario Outline: Do a PROPFIND of various file names
    Given using <dav_version> DAV path
    And user "Alice" has uploaded file with content "uploaded content" to "<file_name>"
    When user "Alice" gets the properties of file "<file_name>" using the WebDAV API
    Then the HTTP status code should be "201"
    And the properties response should contain an etag
    Examples:
      | dav_version | file_name         |
      | old         | /upload.txt       |
      | old         | /strängé file.txt |
      | old         | /नेपाली.txt         |
      | old         | s,a,m,p,l,e.txt   |
      | new         | /upload.txt       |
      | new         | /strängé file.txt |
      | new         | /नेपाली.txt         |
      | new         | s,a,m,p,l,e.txt   |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version | file_name         |
      | spaces      | /upload.txt       |
      | spaces      | /strängé file.txt |
      | spaces      | /नेपाली.txt         |
      | spaces      | s,a,m,p,l,e.txt   |

  @issue-ocis-reva-214 @Tab07ea37
  Scenario Outline: Do a PROPFIND of various file names
    Given using <dav_version> DAV path
    And user "Alice" has uploaded file with content "uploaded content" to "<file_name>"
    When user "Alice" gets the properties of file "<file_name>" using the WebDAV API
    Then the HTTP status code should be "201"
    And the properties response should contain an etag
    And there should be an entry with href containing "<expected_href>" in the response to user "Alice"
    Examples:
      | dav_version | file_name     | expected_href                                 |
      | old         | /C++ file.cpp | remote.php/webdav/C++ file.cpp                |
      | old         | /file #2.txt  | remote.php/webdav/file #2.txt                 |
      | old         | /file ?2.txt  | remote.php/webdav/file ?2.txt                 |
      | old         | /file &2.txt  | remote.php/webdav/file &2.txt                 |
      | new         | /C++ file.cpp | remote.php/dav/files/%username%/C++ file.cpp  |
      | new         | /file #2.txt  | remote.php/dav/files/%username%/file #2.txt   |
      | new         | /file ?2.txt  | remote.php/dav/files/%username%/file ?2.txt   |
      | new         | /file &2.txt  | remote.php/dav/files/%username%/file &2.txt   |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version | file_name     | expected_href                     |
      | spaces      | /C++ file.cpp | dav/spaces/%spaceid%/C++ file.cpp |
      | spaces      | /file #2.txt  | dav/spaces/%spaceid%/file #2.txt  |
      | spaces      | /file ?2.txt  | dav/spaces/%spaceid%/file ?2.txt  |
      | spaces      | /file &2.txt  | dav/spaces/%spaceid%/file &2.txt  |

  @issue-ocis-reva-214 @Tda4e0e3c
  Scenario Outline: Do a PROPFIND of various folder names
    Given using <dav_version> DAV path
    And user "Alice" has created folder "<folder_name>"
    And user "Alice" has uploaded file with content "uploaded content" to "<folder_name>/file1.txt"
    And user "Alice" has uploaded file with content "uploaded content" to "<folder_name>/file2.txt"
    When user "Alice" gets the properties of folder "<folder_name>" with depth 1 using the WebDAV API
    Then the HTTP status code should be "201"
    And there should be an entry with href containing "<expected_href>/" in the response to user "Alice"
    And there should be an entry with href containing "<expected_href>/file1.txt" in the response to user "Alice"
    And there should be an entry with href containing "<expected_href>/file2.txt" in the response to user "Alice"
    Examples:
      | dav_version | folder_name     | expected_href                                  |
      | old         | /upload         | remote.php/webdav/upload                       |
      | old         | /strängé folder | remote.php/webdav/strängé folder              |
      | old         | /C++ folder     | remote.php/webdav/C++ folder                   |
      | old         | /नेपाली           | remote.php/webdav/नेपाली                        |
      | old         | /folder #2.txt  | remote.php/webdav/folder #2.txt                |
      | old         | /folder ?2.txt  | remote.php/webdav/folder ?2.txt                |
      | old         | /folder &2.txt  | remote.php/webdav/folder &2.txt                |
      | new         | /upload         | remote.php/dav/files/%username%/upload         |
      | new         | /strängé folder | remote.php/dav/files/%username%/strängé folder |
      | new         | /C++ folder     | remote.php/dav/files/%username%/C++ folder     |
      | new         | /नेपाली           | remote.php/dav/files/%username%/नेपाली          |
      | new         | /folder #2.txt  | remote.php/dav/files/%username%/folder #2.txt  |
      | new         | /folder ?2.txt  | remote.php/dav/files/%username%/folder ?2.txt  |
      | new         | /folder &2.txt  | remote.php/dav/files/%username%/folder &2.txt  |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version | folder_name     | expected_href                       |
      | spaces      | /upload         | dav/spaces/%spaceid%/upload         |
      | spaces      | /strängé folder | dav/spaces/%spaceid%/strängé folder |
      | spaces      | /C++ folder     | dav/spaces/%spaceid%/C++ folder     |
      | spaces      | /नेपाली           | dav/spaces/%spaceid%/नेपाली          |
      | spaces      | /folder #2.txt  | dav/spaces/%spaceid%/folder #2.txt  |
      | spaces      | /folder ?2.txt  | dav/spaces/%spaceid%/folder ?2.txt  |
      | spaces      | /folder &2.txt  | dav/spaces/%spaceid%/folder &2.txt  |


  @T3ec9affe
  Scenario Outline: Do a PROPFIND of various files inside various folders
    Given using <dav_version> DAV path
    And user "Alice" has created folder "<folder_name>"
    And user "Alice" has uploaded file with content "uploaded content" to "<folder_name>/<file_name>"
    When user "Alice" gets the properties of file "<folder_name>/<file_name>" using the WebDAV API
    Then the HTTP status code should be "201"
    And the properties response should contain an etag
    Examples:
      | dav_version | folder_name                      | file_name                     |
      | old         | /upload                          | abc.txt                       |
      | old         | /strängé folder                  | strängé file.txt              |
      | old         | /C++ folder                      | C++ file.cpp                  |
      | old         | /नेपाली                          | नेपाली                        |
      | old         | /folder #2.txt                   | file #2.txt                   |
      | new         | /upload                          | abc.txt                       |
      | new         | /strängé folder (duplicate #2 &) | strängé file (duplicate #2 &) |
      | new         | /C++ folder                      | C++ file.cpp                  |
      | new         | /नेपाली                          | नेपाली                        |
      | new         | /folder #2.txt                   | file #2.txt                   |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version | folder_name     | file_name        |
      | spaces      | /upload         | abc.txt          |
      | spaces      | /strängé folder | strängé file.txt |
      | spaces      | /C++ folder     | C++ file.cpp     |
      | spaces      | /नेपाली         | नेपाली           |
      | spaces      | /folder #2.txt  | file #2.txt      |

  @issue-ocis-reva-265 @T3ec9affe
  #after fixing all issues delete this Scenario and merge with the one above
  Scenario Outline: Do a PROPFIND of various files inside various folders
    Given using <dav_version> DAV path
    And user "Alice" has created folder "<folder_name>"
    And user "Alice" has uploaded file with content "uploaded content" to "<folder_name>/<file_name>"
    When user "Alice" gets the properties of file "<folder_name>/<file_name>" using the WebDAV API
    Then the HTTP status code should be "201"
    And the properties response should contain an etag
    Examples:
      | dav_version | folder_name    | file_name   |
      | old         | /folder ?2.txt | file ?2.txt |
      | new         | /folder ?2.txt | file ?2.txt |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version | folder_name    | file_name   |
      | spaces      | /folder ?2.txt | file ?2.txt |


  @T2e230cba
  Scenario Outline: A file that is not shared does not have a share-types property
    Given using <dav_version> DAV path
    And user "Alice" has created folder "/test"
    When user "Alice" gets the following properties of folder "/test" using the WebDAV API
      | propertyName   |
      | oc:share-types |
    Then the HTTP status code should be "201"
    And the response should contain an empty property "oc:share-types"
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |

  @files_sharing-app-required @issue-ocis-reva-11 @T0df5db86
  Scenario Outline: A file that is shared to a user has a share-types property
    Given using <dav_version> DAV path
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has created folder "/test"
    And user "Alice" has created a share with settings
      | path        | test  |
      | shareType   | user  |
      | permissions | all   |
      | shareWith   | Brian |
    When user "Alice" gets the following properties of folder "/test" using the WebDAV API
      | propertyName   |
      | oc:share-types |
    Then the HTTP status code should be "200"
    And the response should contain a share-types property with
      | 0 |
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |

  @files_sharing-app-required @issue-ocis-reva-11 @T9543c9a4
  Scenario Outline: A file that is shared to a group has a share-types property
    Given using <dav_version> DAV path
    And group "grp1" has been created
    And user "Alice" has created folder "/test"
    And user "Alice" has created a share with settings
      | path        | test  |
      | shareType   | group |
      | permissions | all   |
      | shareWith   | grp1  |
    When user "Alice" gets the following properties of folder "/test" using the WebDAV API
      | propertyName   |
      | oc:share-types |
    Then the HTTP status code should be "200"
    And the response should contain a share-types property with
      | 1 |
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |

  @public_link_share-feature-required @files_sharing-app-required @issue-ocis-reva-11 @T517b4361
  Scenario Outline: A file that is shared by link has a share-types property
    Given using <dav_version> DAV path
    And user "Alice" has created folder "/test"
    And user "Alice" has created a public link share with settings
      | path        | test |
      | permissions | all  |
    When user "Alice" gets the following properties of folder "/test" using the WebDAV API
      | propertyName   |
      | oc:share-types |
    Then the HTTP status code should be "200"
    And the response should contain a share-types property with
      | 3 |
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |

  @skipOnLDAP @user_ldap-issue-268 @public_link_share-feature-required @files_sharing-app-required @issue-ocis-reva-11 @T3ebfa9c4
  Scenario Outline: A file that is shared by user,group and link has a share-types property
    Given using <dav_version> DAV path
    And user "Brian" has been created with default attributes and without skeleton files
    And group "grp1" has been created
    And user "Alice" has created folder "/test"
    And user "Alice" has created a share with settings
      | path        | test  |
      | shareType   | user  |
      | permissions | all   |
      | shareWith   | Brian |
    And user "Alice" has created a share with settings
      | path        | test  |
      | shareType   | group |
      | permissions | all   |
      | shareWith   | grp1  |
    And user "Alice" has created a public link share with settings
      | path        | test |
      | permissions | all  |
    When user "Alice" gets the following properties of folder "/test" using the WebDAV API
      | propertyName   |
      | oc:share-types |
    Then the HTTP status code should be "200"
    And the response should contain a share-types property with
      | 0 |
      | 1 |
      | 3 |
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |

  @smokeTest @issue-ocis-reva-216 @Ta83564e2
  Scenario Outline: Retrieving private link
    Given using <dav_version> DAV path
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "/somefile.txt"
    When user "Alice" gets the following properties of file "/somefile.txt" using the WebDAV API
      | propertyName   |
      | oc:privatelink |
    Then the HTTP status code should be "201"
    And the single response should contain a property "oc:privatelink" with value like "%(/(index.php/)?f/[0-9]*)%"
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |


  @Td67bafe2
  Scenario Outline: Do a PROPFIND to a nonexistent URL
    When user "Alice" requests "<url>" with "PROPFIND" using basic auth
    Then the HTTP status code should be "404"
    And the value of the item "/d:error/s:message" in the response about user "Alice" should be "<message1>" or "<message2>"
    And the value of the item "/d:error/s:exception" in the response about user "Alice" should be "Sabre\DAV\Exception\NotFound"

    @skipOnOcV10
    Examples:
      | url                                  | message1               | message2           |
      | /remote.php/dav/files/does-not-exist | Resource not found     | Resource not found |
      | /remote.php/dav/does-not-exist       | File not found in root |                    |

    @skipOnOcis
    Examples:
      | url                                  | message1                                     | message2 |
      | /remote.php/dav/files/does-not-exist | Principal with name does-not-exist not found |          |
      | /remote.php/dav/does-not-exist       | File not found: does-not-exist in 'root'     |          |

    @skipOnOcV10 @personalSpace
    Examples:
      | url                                             | message1           | message2 |
      | /remote.php/dav/spaces/%spaceid%/does-not-exist | Resource not found |          |
      | /remote.php/dav/spaces/%spaceid%/file1.txt      | Resource not found |          |

  @issue-ocis-reva-217 @Tb43ea843
  Scenario Outline: add, receive multiple custom meta properties to a file
    Given using <dav_version> DAV path
    And user "Alice" has created folder "/TestFolder"
    And user "Alice" has uploaded file with content "test data one" to "/TestFolder/test1.txt"
    And user "Alice" has set the following properties of file "/TestFolder/test1.txt" using the WebDav API
      | propertyName | propertyValue |
      | testprop1    | AAAAA         |
      | testprop2    | BBBBB         |
    When user "Alice" gets the following properties of file "/TestFolder/test1.txt" using the WebDAV API
      | propertyName |
      | oc:testprop1 |
      | oc:testprop2 |
    Then the HTTP status code should be success
    And as user "Alice" the last response should have the following properties
      | resource              | propertyName | propertyValue   |
      | /TestFolder/test1.txt | testprop1    | AAAAA           |
      | /TestFolder/test1.txt | testprop2    | BBBBB           |
      | /TestFolder/test1.txt | status       | HTTP/1.1 200 OK |
    Examples:
      | dav_version |
      | new         |

    @skipOnOcV10
    Examples:
      | dav_version |
      | old         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |

  @issue-36920 @issue-ocis-reva-217 @T78a41a28
  Scenario Outline: add multiple properties to files inside a folder and do a propfind of the parent folder
    Given using <dav_version> DAV path
    And user "Alice" has created folder "/TestFolder"
    And user "Alice" has uploaded file with content "test data one" to "/TestFolder/test1.txt"
    And user "Alice" has uploaded file with content "test data two" to "/TestFolder/test2.txt"
    And user "Alice" has set the following properties of file "/TestFolder/test1.txt" using the WebDav API
      | propertyName | propertyValue |
      | testprop1    | AAAAA         |
      | testprop2    | BBBBB         |
    And user "Alice" has set the following properties of file "/TestFolder/test2.txt" using the WebDav API
      | propertyName | propertyValue |
      | testprop1    | CCCCC         |
      | testprop2    | DDDDD         |
    When user "Alice" gets the following properties of folder "/TestFolder" using the WebDAV API
      | propertyName |
      | oc:testprop1 |
      | oc:testprop2 |
    Then the HTTP status code should be success
    And as user "Alice" the last response should have the following properties
      | resource              | propertyName | propertyValue          |
      | /TestFolder/test1.txt | testprop1    | AAAAA                  |
      | /TestFolder/test1.txt | testprop2    | BBBBB                  |
      | /TestFolder/test2.txt | testprop1    | CCCCC                  |
      | /TestFolder/test2.txt | testprop2    | DDDDD                  |
      | /TestFolder/          | status       | HTTP/1.1 404 Not Found |
    Examples:
      | dav_version |
      | new         |

    @skipOnOcV10
    Examples:
      | dav_version |
      | old         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |


  @T0e6933e4
  Scenario Outline: Propfind the last modified date of a folder using webdav api
    Given using <dav_version> DAV path
    And user "Alice" has created folder "/test"
    When user "Alice" gets the following properties of folder "/test" using the WebDAV API
      | propertyName      |
      | d:getlastmodified |
    Then the HTTP status code should be "201"
    And the single response should contain a property "d:getlastmodified" with value like "/^[MTWFS][uedhfriatno]{2},\s(\d){2}\s[JFMAJSOND][anebrpyulgctov]{2}\s\d{4}\s\d{2}:\d{2}:\d{2} GMT$/"
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |


  @T358172b6
  Scenario Outline: Propfind the content type of a folder using webdav api
    Given using <dav_version> DAV path
    And user "Alice" has created folder "/test"
    When user "Alice" gets the following properties of folder "/test" using the WebDAV API
      | propertyName     |
      | d:getcontenttype |
    Then the HTTP status code should be "201"
    And the single response should contain a property "d:getcontenttype" with value ""
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |


  @T780ccf49
  Scenario Outline: Propfind the content type of a file using webdav api
    Given using <dav_version> DAV path
    And user "Alice" has uploaded file with content "uploaded content" to "file.txt"
    When user "Alice" gets the following properties of folder "file.txt" using the WebDAV API
      | propertyName     |
      | d:getcontenttype |
    Then the HTTP status code should be "201"
    And the single response should contain a property "d:getcontenttype" with value "text/plain.*"
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |


  @Ta5e782fa
  Scenario Outline: Propfind the etag of a file using webdav api
    Given using <dav_version> DAV path
    And user "Alice" has uploaded file with content "uploaded content" to "file.txt"
    When user "Alice" gets the following properties of folder "file.txt" using the WebDAV API
      | propertyName |
      | d:getetag    |
    Then the HTTP status code should be "201"
    And the single response should contain a property "d:getetag" with value like '%\"[a-z0-9:]{1,32}\"%'
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |


  @T83fff2ce
  Scenario Outline: Propfind the resource type of a file using webdav api
    Given using <dav_version> DAV path
    And user "Alice" has uploaded file with content "uploaded content" to "file.txt"
    When user "Alice" gets the following properties of folder "file.txt" using the WebDAV API
      | propertyName   |
      | d:resourcetype |
    Then the HTTP status code should be "201"
    And the single response should contain a property "d:resourcetype" with value ""
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |


  @Tbb7221f0
  Scenario Outline: Propfind the size of a file using webdav api
    Given using <dav_version> DAV path
    And user "Alice" has uploaded file with content "uploaded content" to "file.txt"
    When user "Alice" gets the following properties of folder "file.txt" using the WebDAV API
      | propertyName |
      | oc:size      |
    Then the HTTP status code should be "201"
    And the single response should contain a property "oc:size" with value "16"
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |


  @Tdf6c91a4
  Scenario Outline: Propfind the size of a folder using webdav api
    Given using <dav_version> DAV path
    And user "Alice" has created folder "/test"
    When user "Alice" gets the following properties of folder "/test" using the WebDAV API
      | propertyName |
      | oc:size      |
    Then the HTTP status code should be "201"
    And the single response should contain a property "oc:size" with value "0"
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |


  @T41d3db7f
  Scenario Outline: Propfind the file id of a file using webdav api
    Given using <dav_version> DAV path
    And user "Alice" has uploaded file with content "uploaded content" to "file.txt"
    When user "Alice" gets the following properties of folder "file.txt" using the WebDAV API
      | propertyName |
      | oc:fileid    |
    Then the HTTP status code should be "201"
    And the single response should contain a property "oc:fileid" with value like '/[a-zA-Z0-9]+/'
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |


  @T08c163e0
  Scenario Outline: Propfind the file id of a folder using webdav api
    Given using <dav_version> DAV path
    And user "Alice" has created folder "/test"
    When user "Alice" gets the following properties of folder "/test" using the WebDAV API
      | propertyName |
      | oc:fileid    |
    Then the HTTP status code should be "201"
    And the single response should contain a property "oc:fileid" with value like '/[a-zA-Z0-9]+/'
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |


  @Tc924bf51
  Scenario Outline: Propfind the owner display name of a file using webdav api
    Given using <dav_version> DAV path
    And user "Alice" has uploaded file with content "uploaded content" to "file.txt"
    When user "Alice" gets the following properties of file "file.txt" using the WebDAV API
      | propertyName          |
      | oc:owner-display-name |
    Then the HTTP status code should be "201"
    And the single response about the file owned by "Alice" should contain a property "oc:owner-display-name" with value "%displayname%"
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |


  @Tf80627c4
  Scenario Outline: Propfind the owner display name of a folder using webdav api
    Given using <dav_version> DAV path
    And user "Alice" has created folder "/test"
    When user "Alice" gets the following properties of folder "/test" using the WebDAV API
      | propertyName          |
      | oc:owner-display-name |
    Then the HTTP status code should be "201"
    And the single response about the file owned by "Alice" should contain a property "oc:owner-display-name" with value "%displayname%"
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |


  @Te8e98cb4
  Scenario Outline: Propfind the permissions on a file using webdav api
    Given using <dav_version> DAV path
    And user "Alice" has uploaded file with content "uploaded content" to "file.txt"
    When user "Alice" gets the following properties of folder "file.txt" using the WebDAV API
      | propertyName   |
      | oc:permissions |
    Then the HTTP status code should be "201"
    And the single response should contain a property "oc:permissions" with value like '/RM{0,1}DNVW/'
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |


  @T2a2bc37d
  Scenario Outline: Propfind the permissions on a folder using webdav api
    Given using <dav_version> DAV path
    And user "Alice" has created folder "/test"
    When user "Alice" gets the following properties of folder "/test" using the WebDAV API
      | propertyName   |
      | oc:permissions |
    Then the HTTP status code should be "201"
    And the single response should contain a property "oc:permissions" with value like '/RM{0,1}DNVCK/'
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_version |
      | spaces      |
