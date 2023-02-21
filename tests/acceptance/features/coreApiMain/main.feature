@api @S788e1c17
Feature: Other tests related to api

  @issue-ocis-reva-100 @Te17dcd7b
  Scenario: robots.txt file should be accessible
    When a user requests "/robots.txt" with "GET" and no authentication
    Then the HTTP status code should be "200"
    And the content in the response should match the following content:
      """
      User-agent: *
      Disallow: /

      """
