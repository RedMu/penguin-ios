Feature: Queues

Scenario: Can navigate to new queue screen
	Given I launch the app
	Then I should see a navigation bar titled "Queues"

	When I touch "Add"
	Then I should see a navigation bar titled "Add Queue"

Scenario: Can save a new queue
	Given I launch the app
	And I touch Add Queue
	
	When I touch the first table cell
	When I type "Frank Queue" into the "Please enter a queue name" text field
	When I touch "Save" 
	When I touch "Save" 
	
	Then I wait to see a navigation bar titled "Queues"
	Then I wait to see "Frank Queue"
	
Scenario: Can cancel a new queue
	Given I launch the app
	And I touch Add Queue
	
	When I touch the first table cell
	When I type "Cancelled Frank Queue" into the "Please enter a queue name" text field
	When I touch "Cancel" 
	When I touch "Cancel"
	When I touch "Cancel" 
	
	Then I wait to see a navigation bar titled "Queues"
	Then I wait to not see "Cancelled Frank Queue"	

	