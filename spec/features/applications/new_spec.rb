require 'rails_helper'

#As a visitor
# When I visit the pet index page
# Then I see a link to "Start an Application"
# When I click this link
# Then I am taken to the new application page where I see a form
# When I fill in this form with my:
#
# Name
# Street Address
# City
# State
# Zip Code
# And I click submit
# Then I am taken to the new application's show page
# And I see my Name, address information, and description of why I would make a good home
# And I see an indicator that this application is "In Progress"
RSpec.describe "Pets edit page" do
  it "links to application page" do
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    scooby = shelter.pets.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
    piglet = shelter.pets.create!(name: 'Piglet',  age: 1, breed: 'Micro Pig', adoptable: true, shelter_id: shelter.id)
    garfield = shelter.pets.create!(name: 'Garfield',  age: 4, breed: 'Orange Tabby Persian', adoptable: true , shelter_id: shelter.id)

    visit "/pets"

    click_link "New Application"

    expect(current_path).to eq("/applications/new")

  end

  it "can fill and submit a new application" do
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    scooby = shelter.pets.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
    piglet = shelter.pets.create!(name: 'Piglet',  age: 1, breed: 'Micro Pig', adoptable: true, shelter_id: shelter.id)
    garfield = shelter.pets.create!(name: 'Garfield',  age: 4, breed: 'Orange Tabby Persian', adoptable: true , shelter_id: shelter.id)

    visit '/applications/new'

    fill_in('name', with: "Toto")
    fill_in('address', with: "2745 Nowhere drive")
    fill_in('city', with: "Topeka")
    fill_in('state', with: "Kansas")
    fill_in('zipcode', with: "4279")

    click_button("Submit Application")

    visit "/applications/#{}"

  end
end
