@api
Feature: upload file
  As a user
  I want to be able to upload files
  So that I can store and share files between multiple client systems

  Background:
    Given using OCS API version "1"
    And user "Alice" has been created with default attributes and without skeleton files

  @smokeTest
  Scenario Outline: upload a file and check etag and download content
    Given using <dav_version> DAV path
    When user "Alice" uploads file with content "uploaded content" to "<file_name>" using the WebDAV API
    Then the HTTP status code should be "201"
    And the following headers should match these regular expressions for user "Alice"
      | ETag | /^"[a-f0-9:\.]{1,32}"$/ |
    And the content of file "<file_name>" for user "Alice" should be "uploaded content"
    Examples:
      | dav_version | file_name         |
      | old         | /upload.txt       |
      | old         | /नेपाली.txt       |
      | old         | /strängé file.txt |
      | old         | /s,a,m,p,l,e.txt  |
      | new         | /upload.txt       |
      | new         | /नेपाली.txt       |
      | new         | /strängé file.txt |
      | new         | /s,a,m,p,l,e.txt  |

    @skipOnRevaMaster
    Examples:
      | dav_version | file_name         |
      | spaces      | /upload.txt       |
      | spaces      | /नेपाली.txt       |
      | spaces      | /strängé file.txt |
      | spaces      | /s,a,m,p,l,e.txt  |


  Scenario Outline: upload a file and check download content
    Given using <dav_version> DAV path
    When user "Alice" uploads file with content "uploaded content" to <file_name> using the WebDAV API
    Then the HTTP status code should be "201"
    And the content of file <file_name> for user "Alice" should be "uploaded content"
    Examples:
      | dav_version | file_name      |
      | old         | "C++ file.cpp" |
      | old         | "file #2.txt"  |
      | new         | "C++ file.cpp" |
      | new         | "file #2.txt"  |

    @skipOnRevaMaster
    Examples:
      | dav_version | file_name      |
      | spaces      | "C++ file.cpp" |
      | spaces      | "file #2.txt"  |

  @issue-1259
  #after fixing all issues delete this Scenario and merge with the one above
  Scenario Outline: upload a file with character '?' in its name and check download content
    Given using <dav_version> DAV path
    When user "Alice" uploads file with content "uploaded content" to <file_name> using the WebDAV API
    Then the HTTP status code should be "201"
    And the content of file <file_name> for user "Alice" should be "uploaded content"
    Examples:
      | dav_version | file_name           |
      | old         | "file ?2.txt"       |
      | old         | " ?fi=le&%#2 . txt" |
      | old         | " # %ab ab?=ed "    |
      | new         | "file ?2.txt"       |
      | new         | " ?fi=le&%#2 . txt" |
      | new         | " # %ab ab?=ed "    |

    @skipOnRevaMaster
    Examples:
      | dav_version | file_name           |
      | spaces      | "file ?2.txt"       |
      | spaces      | " ?fi=le&%#2 . txt" |
      | spaces      | " # %ab ab?=ed "    |


  Scenario Outline: upload a file with comma in the filename and check download content
    Given using <dav_version> DAV path
    When user "Alice" uploads file with content "file with comma" to <file_name> using the WebDAV API
    Then the HTTP status code should be "201"
    And the content of file <file_name> for user "Alice" should be "file with comma"
    Examples:
      | dav_version | file_name      |
      | old         | "sample,1.txt" |
      | old         | ",,,.txt"      |
      | old         | ",,,.,"        |
      | new         | "sample,1.txt" |
      | new         | ",,,.txt"      |
      | new         | ",,,.,"        |

    @skipOnRevaMaster
    Examples:
      | dav_version | file_name      |
      | spaces      | "sample,1.txt" |
      | spaces      | ",,,.txt"      |
      | spaces      | ",,,.,"        |


  Scenario Outline: upload a file into a folder and check download content
    Given using <dav_version> DAV path
    And user "Alice" has created folder "<folder_name>"
    When user "Alice" uploads file with content "uploaded content" to "<folder_name>/<file_name>" using the WebDAV API
    Then the HTTP status code should be "201"
    And the content of file "<folder_name>/<file_name>" for user "Alice" should be "uploaded content"
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

    @skipOnRevaMaster
    Examples:
      | dav_version | folder_name     | file_name        |
      | spaces      | /strängé folder | strängé file.txt |
      | spaces      | /upload         | abc.txt          |
      | spaces      | /C++ folder     | C++ file.cpp     |
      | spaces      | /नेपाली         | नेपाली           |
      | spaces      | /folder #2.txt  | file #2.txt      |

  @issue-1259
    #after fixing all issues delete this Scenario and merge with the one above
  Scenario Outline: upload a file into a folder with character '?' in its name and check download content
    Given using <dav_version> DAV path
    And user "Alice" has created folder "<folder_name>"
    When user "Alice" uploads file with content "uploaded content" to "<folder_name>/<file_name>" using the WebDAV API
    Then the HTTP status code should be "201"
    And the content of file "<folder_name>/<file_name>" for user "Alice" should be "uploaded content"
    Examples:
      | dav_version | folder_name       | file_name    |
      | old         | /folder ?2.txt    | file ?2.txt  |
      | old         | /?fi=le&%#2 . txt | # %ab ab?=ed |
      | new         | /folder ?2.txt    | file ?2.txt  |
      | new         | /?fi=le&%#2 . txt | # %ab ab?=ed |

    @skipOnRevaMaster
    Examples:
      | dav_version | folder_name       | file_name    |
      | spaces      | /folder ?2.txt    | file ?2.txt  |
      | spaces      | /?fi=le&%#2 . txt | # %ab ab?=ed |


  Scenario Outline: attempt to upload a file into a nonexistent folder
    Given using <dav_version> DAV path
    When user "Alice" uploads file with content "uploaded content" to "nonexistent-folder/new-file.txt" using the WebDAV API
    Then the HTTP status code should be "409"
    And as "Alice" folder "nonexistent-folder" should not exist
    And as "Alice" file "nonexistent-folder/new-file.txt" should not exist
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnRevaMaster
    Examples:
      | dav_version |
      | spaces      |

  @issue-1345
  Scenario Outline: uploading file to path with extension .part should not be possible
    Given using <dav_version> DAV path
    When user "Alice" uploads file "filesForUpload/textfile.txt" to "/textfile.part" using the WebDAV API
    Then the HTTP status code should be "400"
    And the DAV exception should be "OCA\DAV\Connector\Sabre\Exception\InvalidPath"
    And the DAV message should be "Can`t upload files with extension .part because these extensions are reserved for internal use."
    And the DAV reason should be "Can`t upload files with extension .part because these extensions are reserved for internal use."
    And user "Alice" should not see the following elements
      | /textfile.part |
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnRevaMaster
    Examples:
      | dav_version |
      | spaces      |


  Scenario Outline: upload a file into a folder with dots in the path and check download content
    Given using <dav_version> DAV path
    And user "Alice" has created folder "<folder_name>"
    When user "Alice" uploads file with content "uploaded content for file name ending with a dot" to "<folder_name>/<file_name>" using the WebDAV API
    Then the HTTP status code should be "201"
    And as "Alice" file "/<folder_name>/<file_name>" should exist
    And the content of file "<folder_name>/<file_name>" for user "Alice" should be "uploaded content for file name ending with a dot"
    Examples:
      | dav_version | folder_name   | file_name   |
      | old         | /upload.      | abc.        |
      | old         | /upload.      | abc .       |
      | old         | /upload.1     | abc.txt     |
      | old         | /upload...1.. | abc...txt.. |
      | old         | /...          | ...         |
      | new         | /..upload     | ..abc       |
      | new         | /upload.      | abc.        |
      | new         | /upload.      | abc .       |
      | new         | /upload.1     | abc.txt     |
      | new         | /upload...1.. | abc...txt.. |
      | new         | /...          | ...         |

    @skipOnRevaMaster
    Examples:
      | dav_version | folder_name   | file_name   |
      | spaces      | /upload.      | abc.        |
      | spaces      | /upload.      | abc .       |
      | spaces      | /upload.1     | abc.txt     |
      | spaces      | /upload...1.. | abc...txt.. |
      | spaces      | /...          | ...         |


  Scenario Outline: upload file with mtime
    Given using <dav_version> DAV path
    When user "Alice" uploads file "filesForUpload/textfile.txt" to "file.txt" with mtime "Thu, 08 Aug 2019 04:18:13 GMT" using the WebDAV API
    Then the HTTP status code should be "201"
    And as "Alice" file "file.txt" should exist
    And as "Alice" the mtime of the file "file.txt" should be "Thu, 08 Aug 2019 04:18:13 GMT"
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnRevaMaster
    Examples:
      | dav_version |
      | spaces      |

  @issue-1248
  Scenario Outline: upload an empty file with mtime
    Given using <dav_version> DAV path
    When user "Alice" uploads file "filesForUpload/zerobyte.txt" to "file.txt" with mtime "Thu, 08 Aug 2019 04:18:13 GMT" using the WebDAV API
    Then the HTTP status code should be "201"
    And as "Alice" file "file.txt" should exist
    And as "Alice" the mtime of the file "file.txt" should be "Thu, 08 Aug 2019 04:18:13 GMT"
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnRevaMaster
    Examples:
      | dav_version |
      | spaces      |


  Scenario Outline: upload a file with mtime in a folder
    Given using <dav_version> DAV path
    And user "Alice" has created folder "testFolder"
    When user "Alice" uploads file "filesForUpload/textfile.txt" to "/testFolder/file.txt" with mtime "Thu, 08 Aug 2019 04:18:13 GMT" using the WebDAV API
    Then the HTTP status code should be "201"
    And as "Alice" file "/testFolder/file.txt" should exist
    And as "Alice" the mtime of the file "/testFolder/file.txt" should be "Thu, 08 Aug 2019 04:18:13 GMT"
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnRevaMaster
    Examples:
      | dav_version |
      | spaces      |

  @issue-1248
  Scenario Outline: upload an empty file with mtime in a folder
    Given using <dav_version> DAV path
    And user "Alice" has created folder "testFolder"
    When user "Alice" uploads file "filesForUpload/zerobyte.txt" to "/testFolder/file.txt" with mtime "Thu, 08 Aug 2019 04:18:13 GMT" using the WebDAV API
    Then the HTTP status code should be "201"
    And as "Alice" file "/testFolder/file.txt" should exist
    And as "Alice" the mtime of the file "/testFolder/file.txt" should be "Thu, 08 Aug 2019 04:18:13 GMT"
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnRevaMaster
    Examples:
      | dav_version |
      | spaces      |


  Scenario Outline: moving a file does not change its mtime
    Given using <dav_version> DAV path
    And user "Alice" has created folder "testFolder"
    When user "Alice" uploads file "filesForUpload/textfile.txt" to "file.txt" with mtime "Thu, 08 Aug 2019 04:18:13 GMT" using the WebDAV API
    And user "Alice" moves file "file.txt" to "/testFolder/file.txt" using the WebDAV API
    Then the HTTP status code should be "201"
    And as "Alice" file "/testFolder/file.txt" should exist
    And as "Alice" the mtime of the file "/testFolder/file.txt" should be "Thu, 08 Aug 2019 04:18:13 GMT"
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnRevaMaster
    Examples:
      | dav_version |
      | spaces      |


  Scenario Outline: overwriting a file changes its mtime
    Given using <dav_version> DAV path
    And user "Alice" has uploaded file with content "first time upload content" to "file.txt"
    When user "Alice" uploads a file with content "Overwrite file" and mtime "Thu, 08 Aug 2019 04:18:13 GMT" to "file.txt" using the WebDAV API
    Then the HTTP status code should be "201"
    And as "Alice" file "file.txt" should exist
    And as "Alice" the mtime of the file "file.txt" should be "Thu, 08 Aug 2019 04:18:13 GMT"
    And the content of file "file.txt" for user "Alice" should be "Overwrite file"
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnRevaMaster
    Examples:
      | dav_version |
      | spaces      |


  Scenario Outline: upload a hidden file and check download content
    Given using <dav_version> DAV path
    And user "Alice" has created folder "/FOLDER"
    When user "Alice" uploads the following files with content "hidden file"
      | path                 |
      | .hidden_file         |
      | /FOLDER/.hidden_file |
    Then the HTTP status code of responses on all endpoints should be "201"
    And as "Alice" the following files should exist
      | path                 |
      | .hidden_file         |
      | /FOLDER/.hidden_file |
    And the content of the following files for user "Alice" should be "hidden file"
      | path                 |
      | .hidden_file         |
      | /FOLDER/.hidden_file |
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnRevaMaster
    Examples:
      | dav_version |
      | spaces      |


  Scenario Outline: upload a file of size zero byte
    Given using <dav_version> DAV path
    When user "Alice" uploads file "filesForUpload/zerobyte.txt" to "/zerobyte.txt" using the WebDAV API
    Then the HTTP status code should be "201"
    And as "Alice" file "zerobyte.txt" should exist
    Examples:
      | dav_version |
      | old         |
      | new         |

    @skipOnRevaMaster
    Examples:
      | dav_version |
      | spaces      |
