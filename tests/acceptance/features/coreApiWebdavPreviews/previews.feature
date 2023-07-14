@api
Feature: previews of files downloaded through the webdav API

  Background:
    Given user "Alice" has been created with default attributes and without skeleton files


  Scenario: download previews with invalid width
    Given using spaces DAV path
    And user "Alice" has uploaded file "filesForUpload/lorem.txt" to "/parent.txt"
    When user "Alice" downloads the preview of "/parent.txt" with width "0" and height "32" using the WebDAV API
    Then the HTTP status code should be "400"
    And the value of the item "/d:error/s:message" in the response about user "Alice" should be "Cannot set width of 0 or smaller!"
    And the value of the item "/d:error/s:exception" in the response about user "Alice" should be "Sabre\DAV\Exception\BadRequest"
#    Examples:
#      | dav-path-version | width |
#      | new              | 0     |
#      | new              | 0.5   |
#      | new              | -1    |
#      | new              | false |
#      | new              | true  |
#      | new              | A     |
#      | new              | %2F   |


  Scenario Outline: download previews with invalid height
    Given user "Alice" has uploaded file "filesForUpload/lorem.txt" to "/parent.txt"
    When user "Alice" downloads the preview of "/parent.txt" with width "32" and height "<height>" using the WebDAV API
    Then the HTTP status code should be "400"
    And the value of the item "/d:error/s:message" in the response about user "Alice" should be "Cannot set height of 0 or smaller!"
    And the value of the item "/d:error/s:exception" in the response about user "Alice" should be "Sabre\DAV\Exception\BadRequest"
    Examples:
      | height |
      | 0      |
      | 0.5    |
      | -1     |
      | false  |
      | true   |
      | A      |
      | %2F    |


  Scenario: download previews of files inside sub-folders
    Given using spaces DAV path
    Given user "Alice" has created folder "subfolder"
    And user "Alice" has uploaded file "filesForUpload/example.gif" to "example.gif"
    When user "Alice" downloads the preview of "example.gif" with width "32" and height "32" using the WebDAV API
    Then the HTTP status code should be "200"
    And the downloaded image should be "32" pixels wide and "32" pixels high
    #    Examples:
#      | dav-path-version | width |


  Scenario Outline: download previews of file types that don't support preview
    Given user "Alice" has uploaded file "filesForUpload/<filename>" to "/<newfilename>"
    When user "Alice" downloads the preview of "/<newfilename>" with width "32" and height "32" using the WebDAV API
    Then the HTTP status code should be "404"
    And the value of the item "/d:error/s:exception" in the response about user "Alice" should be "Sabre\DAV\Exception\NotFound"
    Examples:
      | filename     | newfilename |
      | simple.pdf   | test.pdf    |
      | simple.odt   | test.odt    |
      | new-data.zip | test.zip    |


  Scenario Outline: download previews of different image file types
    Given user "Alice" has uploaded file "filesForUpload/<imageName>" to "/<newImageName>"
    When user "Alice" downloads the preview of "/<newImageName>" with width "32" and height "32" using the WebDAV API
    Then the HTTP status code should be "200"
    And the downloaded image should be "32" pixels wide and "32" pixels high
    Examples:
      | imageName      | newImageName  |
      | testavatar.jpg | testimage.jpg |
      | testavatar.png | testimage.png |


  Scenario: download previews of image after renaming it
    Given user "Alice" has uploaded file "filesForUpload/testavatar.jpg" to "/testimage.jpg"
    And user "Alice" has moved file "/testimage.jpg" to "/testimage.txt"
    When user "Alice" downloads the preview of "/testimage.txt" with width "32" and height "32" using the WebDAV API
    Then the HTTP status code should be "200"
    And the downloaded image should be "32" pixels wide and "32" pixels high


  Scenario Outline: download previews of shared files (to shares folder)
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has uploaded file "filesForUpload/<resource>" to "/<resource>"
    And user "Alice" has shared file "/<resource>" with user "Brian"
    And user "Brian" has accepted share "/<resource>" offered by user "Alice"
    When user "Brian" downloads the preview of "/Shares/<resource>" with width "32" and height "32" using the WebDAV API
    Then the HTTP status code should be "200"
    And the downloaded image should be "32" pixels wide and "32" pixels high
    Examples:
      | resource    |
      | lorem.txt   |
      | example.gif |


  Scenario: download previews of other users files
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has uploaded file "filesForUpload/lorem.txt" to "/parent.txt"
    When user "Brian" downloads the preview of "/parent.txt" of "Alice" with width "32" and height "32" using the WebDAV API
    Then the HTTP status code should be "404"
    And the value of the item "/d:error/s:message" in the response about user "Alice" should be "File not found: parent.txt in '%username%'"
    And the value of the item "/d:error/s:exception" in the response about user "Alice" should be "Sabre\DAV\Exception\NotFound"


  Scenario: download previews of folders
    Given user "Alice" has created folder "subfolder"
    When user "Alice" downloads the preview of "/subfolder/" with width "32" and height "32" using the WebDAV API
    Then the HTTP status code should be "400"
    And the value of the item "/d:error/s:message" in the response about user "Alice" should be "Unsupported file type"
    And the value of the item "/d:error/s:exception" in the response about user "Alice" should be "Sabre\DAV\Exception\BadRequest"


  Scenario: download previews of not-existing files
    When user "Alice" downloads the preview of "/parent.txt" with width "32" and height "32" using the WebDAV API
    Then the HTTP status code should be "404"
    And the value of the item "/d:error/s:message" in the response about user "Alice" should be "File with name parent.txt could not be located"
    And the value of the item "/d:error/s:exception" in the response about user "Alice" should be "Sabre\DAV\Exception\NotFound"


  Scenario: preview content changes with the change in file content
    Given user "Alice" has uploaded file "filesForUpload/lorem.txt" to "/parent.txt"
    And user "Alice" has downloaded the preview of "/parent.txt" with width "32" and height "32"
    When user "Alice" uploads file with content "this is a file to upload" to "/parent.txt" using the WebDAV API
    Then the HTTP status code should be "204"
    And as user "Alice" the preview of "/parent.txt" with width "32" and height "32" should have been changed

  @issue-2538
  Scenario: when owner updates a shared file, previews for sharee are also updated (to shared folder)
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has uploaded file "filesForUpload/lorem.txt" to "/parent.txt"
    And user "Alice" has shared file "/parent.txt" with user "Brian"
    And user "Brian" has accepted share "/parent.txt" offered by user "Alice"
    And user "Brian" has downloaded the preview of "/Shares/parent.txt" with width "32" and height "32"
    When user "Alice" uploads file with content "this is a file to upload" to "/parent.txt" using the WebDAV API
    Then the HTTP status code should be "204"
    And as user "Brian" the preview of "/Shares/parent.txt" with width "32" and height "32" should have been changed


  Scenario: it should update the preview content if the file content is updated (content with UTF chars)
    Given user "Alice" has uploaded file "filesForUpload/lorem.txt" to "/lorem.txt"
    And user "Alice" has uploaded file with content "सिमसिमे पानी" to "/lorem.txt"
    When user "Alice" downloads the preview of "/lorem.txt" with width "32" and height "32" using the WebDAV API
    Then the HTTP status code should be "200"
    And the downloaded image should be "32" pixels wide and "32" pixels high
    And the downloaded preview content should match with "सिमसिमे-पानी.png" fixtures preview content


  Scenario: updates to a file should change the preview for both sharees and sharers
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has created folder "FOLDER"
    And user "Alice" has uploaded file with content "file to upload" to "/FOLDER/lorem.txt"
    And user "Alice" has shared folder "FOLDER" with user "Brian"
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"
    And user "Alice" has downloaded the preview of "/FOLDER/lorem.txt" with width "32" and height "32"
    And user "Brian" has downloaded the preview of "Shares/FOLDER/lorem.txt" with width "32" and height "32"
    When user "Alice" uploads file "filesForUpload/lorem.txt" to "/FOLDER/lorem.txt" using the WebDAV API
    Then the HTTP status code should be "204"
    And as user "Alice" the preview of "/FOLDER/lorem.txt" with width "32" and height "32" should have been changed
    And as user "Brian" the preview of "Shares/FOLDER/lorem.txt" with width "32" and height "32" should have been changed
    When user "Brian" uploads file with content "new uploaded content" to "Shares/FOLDER/lorem.txt" using the WebDAV API
    Then the HTTP status code should be "204"
    And as user "Alice" the preview of "/FOLDER/lorem.txt" with width "32" and height "32" should have been changed
    And as user "Brian" the preview of "Shares/FOLDER/lorem.txt" with width "32" and height "32" should have been changed


  Scenario: updates to a group shared file should change the preview for both sharees and sharers
    Given group "grp1" has been created
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Carol" has been created with default attributes and without skeleton files
    And user "Brian" has been added to group "grp1"
    And user "Carol" has been added to group "grp1"
    And user "Alice" has created folder "FOLDER"
    And user "Alice" has uploaded file with content "file to upload" to "/FOLDER/lorem.txt"
    And user "Alice" has shared folder "/FOLDER" with group "grp1"
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"
    And user "Carol" has accepted share "/FOLDER" offered by user "Alice"
    And user "Alice" has downloaded the preview of "/FOLDER/lorem.txt" with width "32" and height "32"
    And user "Brian" has downloaded the preview of "Shares/FOLDER/lorem.txt" with width "32" and height "32"
    And user "Carol" has downloaded the preview of "Shares/FOLDER/lorem.txt" with width "32" and height "32"
    When user "Alice" uploads file "filesForUpload/lorem.txt" to "/FOLDER/lorem.txt" using the WebDAV API
    Then the HTTP status code should be "204"
    And as user "Alice" the preview of "/FOLDER/lorem.txt" with width "32" and height "32" should have been changed
    And as user "Brian" the preview of "Shares/FOLDER/lorem.txt" with width "32" and height "32" should have been changed
    And as user "Carol" the preview of "Shares/FOLDER/lorem.txt" with width "32" and height "32" should have been changed
    When user "Brian" uploads file with content "new uploaded content" to "Shares/FOLDER/lorem.txt" using the WebDAV API
    Then the HTTP status code should be "204"
    And as user "Alice" the preview of "/FOLDER/lorem.txt" with width "32" and height "32" should have been changed
    And as user "Brian" the preview of "Shares/FOLDER/lorem.txt" with width "32" and height "32" should have been changed
    And as user "Carol" the preview of "Shares/FOLDER/lorem.txt" with width "32" and height "32" should have been changed
