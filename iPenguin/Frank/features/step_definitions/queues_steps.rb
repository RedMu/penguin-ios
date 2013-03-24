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
