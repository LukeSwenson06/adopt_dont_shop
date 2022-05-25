class AdminController < ApplicationController

  def index
    @shelters = Shelter.reverse_alphabetical
    @pending_shelters = Shelter.pending_applications
  end

  def show
    @application = Application.find(params[:id])
  end
end
