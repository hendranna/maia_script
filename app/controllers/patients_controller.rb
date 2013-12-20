class PatientsController < ApplicationController

	def index
		 @patients = Patient.all

		 respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @patients }
    end
  end

	def show
	  @patient = Patient.find(params[:id])

	  respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @patient }
    end
  end

	
end
