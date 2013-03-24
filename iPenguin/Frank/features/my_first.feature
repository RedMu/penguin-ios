Feature: 
  As an user of the penguin app
  I want to be able to view/edit penguin queues on the server
  So I can view/edit stories on said queues

Scenario: 
    Create a queue
Given I launch the app
Then I should be on the Home screen

When I navigate to "New Queue"
Then I should be on the Add Queue screen