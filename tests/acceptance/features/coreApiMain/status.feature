@api @Sd4d08931
Feature: Status

  @smokeTest @Ta76ccb47
  Scenario: Status.php is correct
    When the administrator requests status.php
    Then the status.php response should include
      """
      {"installed":true,"maintenance":false,"needsDbUpgrade":false,"version":"$CURRENT_VERSION","versionstring":"$CURRENT_VERSION_STRING","edition":"$EDITION","productname":"$PRODUCTNAME","product":"$PRODUCT"}
      """
