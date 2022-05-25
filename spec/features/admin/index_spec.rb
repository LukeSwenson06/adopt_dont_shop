require 'rails_helper'

RSpec.describe do
  before :each do
    ApplicationPet.destroy_all
    Pet.destroy_all
    Shelter.destroy_all
    Application.destroy_all

    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @scooby = @shelter_1.pets.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true)
    @piglet = @shelter_2.pets.create!(name: 'Piglet',  age: 1, breed: 'Micro Pig', adoptable: true)

    @application_1 = Application.create!(name: 'Shaggy', address: '2541 Spooky Lane', city: 'Coolsville', state: 'Ohio', zipcode: '12345', rationale: 'I want a best friend to eat Scooby snacks with', status: 'Pending')
    @application_2 = Application.create!(name: 'Michael Vick', address: '38747 Brooklyn Lane', city: 'Brooklyn', state: 'New York', zipcode: '11200', rationale: 'I need fighters for my underground dog fight club', status: 'In-Progress')
  end

  it 'can list shelters in reverse alphabetical order' do
    visit '/admin/shelters'
# save_and_open_page
    within "#reverse-alphabetical-shelters" do
      expect(@shelter_2.name).to appear_before(@shelter_3.name)
      expect(@shelter_3.name).to appear_before(@shelter_1.name)
      expect(@shelter_1.name).to_not appear_before(@shelter_2.name)
      expect(@shelter_3.name).to_not appear_before(@shelter_2.name)
    end
  end

  it 'can list all pending applications across all shelters' do
    visit "/applications/#{@application_1.id}"
    fill_in :search, with: "Scooby"
    click_on "Search Pet Name"
    click_button "Adopt Scooby"
    fill_in :rationale, with: "I love pets"
    click_button "Submit Application"

    visit '/admin/shelters'

    within '#shelters-with-pending-applications' do
      expect(page).to have_content("Aurora shelter")
      expect(page).to_not have_content("Fancy Pets of Colorado")
    end
  end
end
