class AdminController < ApplicationController

  def index
    @shelters = Shelter.reverse_alphabetical
    @pending_shelters = Shelter.pending_applications
  end

  def show
    @application = Application.find(params[:id])
  end

  def update
    application = Application.find(params[:id])
    @application_pet = ApplicationPet.find_by(application_id: params[:id], pet_id: params[:pet_id])
      if params[:status] == "Approved"
        @application_pet.update(status: 'Approved')
      else
        @application_pet.update(status: 'Rejected')
      end
    redirect_to "/admin/applications/#{@application.id}"
  end
end
