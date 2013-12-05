require 'spec_helper'

feature "Things admin" do
  background do
#    mocha_teardown
  end

  scenario "Viewing a list of things" do
    visit "/things"
    page.should have_content("things")
#    flunk
  end
end
