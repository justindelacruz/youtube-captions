Given(/^there's a source named "(.*?)"$/) do |name|
  @source = FactoryGirl.create(:source, name: name)
end

When(/^I am on the homepage$/) do
  visit "/"
end

Then(/^I should see the "(.*?)" source$/) do |name|
  @source = Source.find_by_name(name)
  expect(page).to have_content(@source.name)
end
