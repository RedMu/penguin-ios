Then(/^I should be on the Queues screen$/) do
  check_element_exists "view view:'UITableView' marked:'Queues'"
end

When(/^I touch Add Queue$/) do
  touch "view view:'UINavigationButton' marked:'Add'"
end

Then(/^I should be on the Add Queue screen$/) do
  check_element_exists "view view:'UINavigationItemView' marked:'Add Queue'"
  check_element_exists "view view:'UITextFieldLabel' marked:'Please enter a queue name'"
  check_element_exists "view view:'UINavigationButton' marked:'Save'"
  check_element_exists "view view:'UINavigationButton' marked:'Cancel'"    
end

def swipeIndDirection(uiquery, direction)
    views_touched = frankly_map( uiquery, 'swipeInDirection:',"#{direction}"   )
    raise "could not find anything matching [#{uiquery}] to touch" if
    views_touched.empty?
end

When /^I swipe "([^\"]*)" the "([^\"]*)"$/ do |direction,mark|
    swipeIndDirection("view marked:'#{mark}'", direction)
    sleep 3
end

Then /^I delete queue named "([^\"]*)"$/ do |mark| 
	swipeIndDirection("view marked:'#{mark}'", "right")
	When I touch "Confirm Deletion"
	Then I wait to see "Are you sure?"
	When I touch "OK"
#	Then I wait to not see "'#{mark}'"
end