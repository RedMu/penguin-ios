Feature: 
	As an iPenguin app user 
	I need to be able to view and manipulate Queues
	So that I can keep track of multiple merge queues

Scenario: Can navigate to new queue screen
	Given I launch the app
	Then I should see a navigation bar titled "Queues"

	When I touch "Add"
	Then I should see a navigation bar titled "Add Queue"

Scenario: Can save a new queue
	Given I launch the app using iOS 6.1
	And I touch Add Queue
	
	When I touch the first table cell
	When I type "Frank Queue" into the "Please enter a queue name" text field
	When I touch "Save" 
	When I touch "Save" 
	
	Then I wait to see a navigation bar titled "Queues"
	Then I wait to see "Frank Queue"
	
Scenario: Can cancel a new queue
	Given I launch the app using iOS 6.1
	And I touch Add Queue
	
	When I touch the first table cell
	When I type "Cancelled Frank Queue" into the "Please enter a queue name" text field
	When I touch "Cancel" 
	When I touch "Cancel"
	When I touch "Cancel" 
	
	Then I wait to see a navigation bar titled "Queues"
	Then I wait to not see "Cancelled Frank Queue"	

Scenario: Can delete a queue
	Given I launch the app using iOS 6.1
	And I touch Add Queue
	When I touch the first table cell
	When I type "Deleted Frank Queue" into the "Please enter a queue name" text field
	When I touch "Save" 
	When I touch "Save"
	Then I wait to see a navigation bar titled "Queues" 
	Then I wait to see "Deleted Frank Queue"	
	
	When I swipe "right" the "Deleted Frank Queue"
	When I touch "Confirm Deletion"
	Then I wait to see "Are you sure?"
	When I touch "OK"
	Then I wait to not see "Deleted Frank Queue"
	
Scenario: Can cancel delete a queue
	Given I launch the app using iOS 6.1
	And I touch Add Queue
	When I touch the first table cell
	When I type "Cancel Deleted Frank Queue" into the "Please enter a queue name" text field
	When I touch "Save" 
	When I touch "Save"
	Then I wait to see a navigation bar titled "Queues" 
	Then I wait to see "Cancel Deleted Frank Queue"	
	
	When I swipe "right" the "Cancel Deleted Frank Queue"
	When I touch "Confirm Deletion"
	Then I wait to see "Are you sure?"
	When I touch "Cancel" 
	Then I wait to see "Cancel Deleted Frank Queue"
	
Scenario: Teardown until better means
	Given I launch the app using iOS 6.1
	Then I delete queue named "Cancel Deleted Frank"
	Then I delete queue named "Frank Queue"