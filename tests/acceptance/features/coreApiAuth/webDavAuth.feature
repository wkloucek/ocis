@api @S5c4a9b31
Feature: auth

  Background:
    Given user "Alice" has been created with default attributes and without skeleton files

  @smokeTest @T5ab84516
  Scenario: using WebDAV anonymously
    When a user requests "/remote.php/webdav" with "PROPFIND" and no authentication
    Then the HTTP status code should be "401"

  @smokeTest @skipOnOcV10 @personalSpace @Ta0afc26e
  Scenario: using spaces WebDAV anonymously
    When user "Alice" requests "/dav/spaces/%spaceid%" with "PROPFIND" and no authentication
    Then the HTTP status code should be "401"

  @smokeTest @Tc69833d3
  Scenario Outline: using WebDAV with basic auth
    When user "Alice" requests "<dav_path>" with "PROPFIND" using basic auth
    Then the HTTP status code should be "207"
    Examples:
      | dav_path           |
      | /remote.php/webdav |

    @skipOnOcV10 @personalSpace
    Examples:
      | dav_path              |
      | /dav/spaces/%spaceid% |
