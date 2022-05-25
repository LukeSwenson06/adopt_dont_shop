require 'rails_helper'

RSpec.describe "Admin Show Page", type: :feature do
  before :each do
    @shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

    @scooby = @shelter.pets.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: @shelter.id)
    @piglet = @shelter.pets.create!(name: 'Piglet',  age: 1, breed: 'Micro Pig', adoptable: true, shelter_id: @shelter.id)
    @garfield = @shelter.pets.create!(name: 'Garfield',  age: 4, breed: 'Orange Tabby Persian', adoptable: true , shelter_id: @shelter.id)

    @application_1 = Application.create!(name: 'Shaggy', address: '2541 Spooky Lane', city: 'Coolsville', state: 'Ohio', zipcode: '12345', rationale: 'I want a best friend to eat Scooby snacks with', status: 'In-progress')
    @application_3 = Application.create!(name: 'Michael Scott', address: '4543 Albuquerque Lane', city: 'Albuquerque', state: 'New Mexico', zipcode: '13579', rationale: 'I am sad and need company', status: 'In-progress')

    @application_pet1 = ApplicationPet.create!(pet_id: @scooby.id, application_id: @application_1.id)
    @application_pet2 = ApplicationPet.create!(pet_id: @piglet.id, application_id: @application_1.id)
    @application_pet3 = ApplicationPet.create!(pet_id: @scooby.id, application_id: @application_3.id)
    @application_pet4 = ApplicationPet.create!(pet_id: @garfield.id, application_id: @application_3.id)
  end

  it "can click a button next to every pet and have a indicator saying the pet was approved/rejected" do
    visit "/admin/applications/#{@application_1.id}"
    # save_and_open_page
    expect(current_path).to eq("/admin/applications/#{@application_1.id}")

    within "#application-#{@application_1.id}" do
      expect(page).to have_button("Approve #{@scooby.name}")
      expect(page).to have_button("Reject #{@scooby.name}")
      expect(page).to_not have_content("Approved")
      expect(page).to_not have_content("Rejected")

      save_and_open_page
      click_button "Approve #{@scooby.name}"
      visit "/admin/applications/#{@application_1.id}"

      expect(page).to_not have_button("Approve #{@scooby.name}")
      expect(page).to_not have_button("Reject #{@scooby.name}")
      expect(page).to have_content("Approved")
      expect(page).to have_content("Rejected")
    end

    within "#application-#{@application_3.id}" do
      expect(page).to have_button("Reject #{@garfield.name}")
      expect(page).to have_button("Approve #{@garfield.name}")
      expect(page).to_not have_content("Approved")
      expect(page).to_not have_content("Rejected")

      click_button "Reject #{@garfield.name}"
      visit "/admin/applications/#{@application_3.id}"
      expect(page).to_not have_button("Reject #{@garfield.name}")
      expect(page).to_not have_button("Approve #{@garfield.name}")
      expect(page).to have_content("Rejected")
      expect(page).to_not have_content("Approved")
    end
  end

  it 'can approve/reject an application for a pet and not impact another application for the same pet' do
    visit "/admin/applications/#{@application_1.id}"
    click_button "Approve #{@scooby.name}"
    visit "/admin/applications/#{@application_3.id}"

    expect(page).to have_button("Reject #{@scooby.name}")
    expect(page).to have_button("Approve #{@scooby.name}")
    expect(page).to_not have_content("Approved")
    expect(page).to_not have_content("Rejected")
  end
end
