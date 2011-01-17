Feature: Manage Sites
  In order to keep sites up-to-date
  As an admin
  I want to fully manage sites
  
  Scenario: List Sites
    Given I have sites named IHD, DaaS
    When I go to the list of sites
    Then I should see "Sites"
    And I should see "New Site"
    And I should see "IHD"
    And I should see "DaaS"

  Scenario: Create a Site
    Given I have no sites
    And I am on the list of sites
    When I follow "New Site"
    And I fill in "site_name" with "IHD"
    And I fill in "site_domain" with "www.idolhands.com"
    And I press "Save"
    Then I should see "IHD"
    And I should have 1 site

  Scenario: Delete Site
    Given I have sites named IHD
    When I go to the list of sites
    And I follow "Delete" within "[@class='crud_links']"
    Then I should not see "IHD"
  
  Scenario: View Site
    Given I have sites named IHD
    When I go to the list of sites
    And I follow "View" within "[@class='crud_links']"
    Then I should see "IHD"
  
  Scenario: Edit Site from Sites List
    Given I have sites named IHD
    When I go to the list of sites
    And I follow "Edit" within "[@class='crud_links']"
    And I fill in "site_name" with "Some Site"
    And I press "Save"
    Then I should see "About This Site"
    And I should see "Some Site"
    
  Scenario: Edit Site from Site Show
    Given I have sites named IHD
    When I go to the list of sites
    And I follow "View" within "[@class='crud_links']"
    And I follow "Edit"
    And I fill in "site_name" with "Another Site"
    And I press "Save"
    Then show me the page
    Then I should see "About This Site"
    And I should see "Another Site"
  
  Scenario: Activate a Site
    Given I have sites named IHD
    When I go to the list of sites
    And I follow "Edit" within "[@class='crud_links']"
    And I select "Active" from "site_state"
    Then the div element with the id redirect_field should not be visible
    And I press "Save"
    Then I should see "Active"
    And I should see "Activation Date"

  Scenario: Deactivate a Site
    Given I have sites named IHD
    When I go to the list of sites
    And I follow "Edit" within "[@class='crud_links']"
    And I select "Inactive" from "site_state"
    Then the div element with the id redirect_field should be visible
    And I press "Save"
    Then I should see "Inactive"
    And I should not see "Activation Date"
