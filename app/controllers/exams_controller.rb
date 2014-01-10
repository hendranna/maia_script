class ExamsController < ApplicationController

	def index
		@patient = Patient.find(params[:patient_id])
		@exams = Exam.all

		respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @exams}
    end
	end

	

	def show
		@patient = Patient.find(params[:patient_id])
		@exam = Exam.find(params[:id])
		@image = image.to_s

		respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @exam }
    end
	end

	
end
  